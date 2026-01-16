import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/mock_home_repository.dart';
import '../../data/models/plant_model.dart';

final homeRepositoryProvider = Provider<MockHomeRepository>((ref) {
  return MockHomeRepository();
});

final recentlyIdentifiedProvider = FutureProvider<List<Plant>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getRecentlyIdentified();
});

final trendingPlantsProvider = FutureProvider<List<Plant>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getTrendingPlants();
});
