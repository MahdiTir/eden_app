import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/plant_classifier_service.dart';

// Provider for the PlantClassifierService
final plantClassifierServiceProvider = Provider<PlantClassifierService>((ref) {
  return PlantClassifierService();
});

// State for Scan Mode
class ScanModeNotifier extends Notifier<bool> {
  @override
  bool build() => false; // Default Offline

  void toggle() => state = !state;
  void setMode(bool isOnline) => state = isOnline;
}

final scanModeProvider = NotifierProvider<ScanModeNotifier, bool>(
  ScanModeNotifier.new,
);

// Controller to handle logic
class ScanController extends AsyncNotifier<List<PredictionResult>> {
  @override
  List<PredictionResult> build() {
    return [];
  }

  Future<void> identifyPlant(File imageFile) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final isOnline = ref.read(scanModeProvider);
      final service = ref.read(plantClassifierServiceProvider);
      return service.classify(imageFile, isOnline: isOnline);
    });
  }
}

final scanControllerProvider =
    AsyncNotifierProvider<ScanController, List<PredictionResult>>(
      ScanController.new,
    );
