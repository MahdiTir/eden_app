import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/supabase_config.dart';
import '../models/plant_profile.dart';

final plantDetailsServiceProvider = Provider<PlantDetailsService>((ref) {
  return PlantDetailsService();
});

class PlantDetailsService {
  Future<PlantProfile?> fetchPlantDetails(String plantName) async {
    final url = Uri.parse('${SupabaseConfig.url}/functions/v1/LLM_INFO');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
      },
      body: jsonEncode({'plant_name': plantName}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
        return PlantProfile.fromJson(jsonResponse['data']);
      }
    }
    return null;
  }
}
