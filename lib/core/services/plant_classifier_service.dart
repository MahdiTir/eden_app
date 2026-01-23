import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../config/supabase_config.dart';

class PredictionResult {
  final String label;
  final double probability;
  final double percentage;

  PredictionResult({
    required this.label,
    required this.probability,
    required this.percentage,
  });

  @override
  String toString() {
    return '$label: ${percentage.toStringAsFixed(2)}%';
  }
}

class PlantClassifierService {
  Interpreter? _interpreter;
  Map<String, dynamic>? _labelMapping;
  Map<int, String>? _idxToLabel;

  static const String _modelPath =
      'assets/plant_identification_mobilenetv3_family.tflite';
  static const String _labelPath = 'assets/family_label_mapping.json';
  static const int _inputSize = 224;

  // Supabase Edge Function URL
  static const String _onlineApiUrl =
      'https://ptyyqdgbvigvzthsqtmw.supabase.co/functions/v1/suba_to_HF';

  // Initialize the model (Offline)
  Future<void> loadModel() async {
    try {
      if (_interpreter != null) return;

      // Load the TFLite model
      _interpreter = await Interpreter.fromAsset(_modelPath);
      debugPrint('Model loaded successfully');

      // Load label mapping
      final jsonString = await rootBundle.loadString(_labelPath);
      _labelMapping = json.decode(jsonString);

      // Create reverse mapping (index to label)
      _idxToLabel = {};
      _labelMapping!.forEach((key, value) {
        _idxToLabel![value as int] = key;
      });

      debugPrint('Labels loaded: ${_labelMapping!.length} classes');
    } catch (e) {
      debugPrint('Error loading model: $e');
      rethrow;
    }
  }

  // Preprocess image for TFLite
  List<List<List<List<double>>>> _preprocessImage(File imageFile) {
    // Read image
    img.Image? image = img.decodeImage(imageFile.readAsBytesSync());
    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Resize to 224x224
    img.Image resizedImage = img.copyResize(
      image,
      width: _inputSize,
      height: _inputSize,
    );

    // Convert to Float32List with normalization [0, 1]
    var input = List.generate(
      1,
      (b) => List.generate(
        _inputSize,
        (y) => List.generate(
          _inputSize,
          (x) => List.generate(3, (c) {
            final pixel = resizedImage.getPixel(x, y);
            double value = 0;
            if (c == 0) value = pixel.r / 255.0;
            if (c == 1) value = pixel.g / 255.0;
            if (c == 2) value = pixel.b / 255.0;
            return value;
          }),
        ),
      ),
    );

    return input;
  }

  // Softmax function
  List<double> _softmax(List<double> logits) {
    double maxLogit = logits.reduce((a, b) => a > b ? a : b);
    List<double> exps = logits.map((x) => exp(x - maxLogit)).toList();
    double sumExps = exps.reduce((a, b) => a + b);
    return exps.map((x) => x / sumExps).toList();
  }

  // Run Offline Inference
  Future<List<PredictionResult>> _classifyOffline(
    File imageFile, {
    int topK = 5,
  }) async {
    if (_interpreter == null || _idxToLabel == null) {
      await loadModel();
    }

    // Preprocess image
    var input = _preprocessImage(imageFile);

    // Prepare output buffer
    var output = List.filled(
      1,
      List<double>.filled(_labelMapping!.length, 0.0),
    ).map((e) => List<double>.filled(_labelMapping!.length, 0.0)).toList();

    // Run inference
    _interpreter!.run(input, output);

    // Apply softmax to convert logits to probabilities
    List<double> probabilities = _softmax(output[0]);

    // Get top K predictions
    List<int> indices = List.generate(probabilities.length, (i) => i);
    indices.sort((a, b) => probabilities[b].compareTo(probabilities[a]));

    List<PredictionResult> results = [];
    for (int i = 0; i < topK && i < indices.length; i++) {
      int idx = indices[i];
      results.add(
        PredictionResult(
          label: _idxToLabel![idx] ?? 'Unknown',
          probability: probabilities[idx],
          percentage: probabilities[idx] * 100,
        ),
      );
    }

    return results;
  }

  Future<List<PredictionResult>> _classifyOnline(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // In Supabase Edge Functions, we usually pass the anon key in Authorization or specific header if required.

      final response = await http.post(
        Uri.parse(_onlineApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
        },
        body: jsonEncode({"imageBase64": base64Image}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        // Expecting array based on user example: [ { "success": true, "topPrediction": ..., "allPredictions": [...] } ]
        if (jsonResponse.isNotEmpty) {
          final data = jsonResponse[0];
          if (data['success'] == true) {
            final predictions = data['allPredictions'] as List;
            if (predictions.isNotEmpty) {
              // Map to PredictionResult
              // User wants Top Prediction only for display later, but we can return list
              // But wait, the user example online response has "confidence" as raw double e.g. 0.443...

              return predictions.map((p) {
                final double conf = (p['confidence'] is int)
                    ? (p['confidence'] as int).toDouble()
                    : (p['confidence'] as double);
                return PredictionResult(
                  label: p['label'],
                  probability: conf,
                  percentage: conf * 100,
                );
              }).toList();
            }
          }
        }
        throw Exception('Failed to identify plant: Invalid response structure');
      } else {
        throw Exception(
          'Failed to identify plant: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Online identification failed: $e');
      rethrow;
    }
  }

  // Main method to classify based on mode
  Future<List<PredictionResult>> classify(
    File imageFile, {
    bool isOnline = false,
  }) async {
    if (isOnline) {
      return await _classifyOnline(imageFile);
    } else {
      return await _classifyOffline(imageFile);
    }
  }

  void dispose() {
    _interpreter?.close();
  }
}
