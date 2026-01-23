import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/plant_profile.dart';
import '../../data/services/plant_details_service.dart';

final plantProfileProvider = FutureProvider.family<PlantProfile?, String>((
  ref,
  plantName,
) async {
  final service = ref.watch(plantDetailsServiceProvider);
  return service.fetchPlantDetails(plantName);
});
