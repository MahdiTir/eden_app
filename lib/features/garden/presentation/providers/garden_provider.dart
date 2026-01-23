import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../data/models/garden_models.dart';
import '../../data/repositories/garden_repository.dart';

/// Provider for garden repository
final gardenRepositoryProvider = Provider<GardenRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return GardenRepository(supabase);
});

/// Provider for user's garden data
final userGardenProvider = FutureProvider.autoDispose<UserGarden?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;

  final repository = ref.watch(gardenRepositoryProvider);
  return repository.getUserGarden(user.id);
});

/// Provider for roadmap rewards
final roadmapRewardsProvider = Provider.autoDispose<List<RoadmapReward>>((ref) {
  final gardenAsync = ref.watch(userGardenProvider);
  final garden = gardenAsync.value;

  if (garden == null) {
    // Return default locked rewards for guest
    return GardenRepository(
      ref.watch(supabaseClientProvider),
    ).getRoadmapRewards(0);
  }

  return GardenRepository(
    ref.watch(supabaseClientProvider),
  ).getRoadmapRewards(garden.level);
});

/// Provider for daily reward availability
final dailyRewardAvailableProvider = FutureProvider.autoDispose<bool>((
  ref,
) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return false;

  final repository = ref.watch(gardenRepositoryProvider);
  return repository.isDailyRewardAvailable(user.id);
});

/// State notifier for claiming daily reward
class DailyRewardNotifier extends Notifier<AsyncValue<int?>> {
  @override
  AsyncValue<int?> build() => const AsyncValue.data(null);

  Future<void> claimReward() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final repository = ref.read(gardenRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repository.claimDailyReward(user.id));
  }
}

/// Provider for daily reward claiming
final dailyRewardNotifierProvider =
    NotifierProvider.autoDispose<DailyRewardNotifier, AsyncValue<int?>>(
      DailyRewardNotifier.new,
    );
