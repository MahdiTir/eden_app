import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/garden_models.dart';

/// Repository for garden-related Supabase operations
class GardenRepository {
  final SupabaseClient _supabase;

  GardenRepository(this._supabase);

  /// Get or create user's garden
  Future<String> getOrCreateGarden(String userId) async {
    // Try to fetch existing garden
    final existing = await _supabase
        .from('my_garden')
        .select('garden_id')
        .eq('id', userId)
        .maybeSingle();

    if (existing != null) {
      return existing['garden_id'].toString();
    }

    // Create new garden for user
    final result = await _supabase
        .from('my_garden')
        .insert({'id': userId})
        .select('garden_id')
        .single();

    return result['garden_id'].toString();
  }

  /// Get user's garden with XP from users table
  Future<UserGarden> getUserGarden(String userId) async {
    final gardenId = await getOrCreateGarden(userId);

    // Get user XP
    final userResult = await _supabase
        .from('users')
        .select('xp_total')
        .eq('id', userId)
        .single();

    final xpTotal = (userResult['xp_total'] as num?)?.toInt() ?? 0;

    // Get garden plants
    final plantsResult = await _supabase
        .from('garden_plants')
        .select('''
          plant_id,
          unlocked_date,
          plants (
            scientific_name,
            common_name,
            family,
            region,
            occurrence_map_url
          )
        ''')
        .eq('garden_id', gardenId)
        .order('unlocked_date', ascending: false);

    final plants = (plantsResult as List)
        .map((json) => GardenPlant.fromJson(json as Map<String, dynamic>))
        .toList();

    return UserGarden(
      gardenId: gardenId,
      userId: userId,
      xpTotal: xpTotal,
      plants: plants,
    );
  }

  /// Claim daily reward - calls server-side RPC to add XP
  /// Returns the XP earned
  Future<int> claimDailyReward(String userId) async {
    // Check if already claimed today
    final today = DateTime.now().toUtc().toIso8601String().split('T')[0];

    final existing = await _supabase
        .from('xp_history')
        .select('xp_id')
        .eq('id', userId)
        .eq('action_type', 'daily_reward')
        .gte('created_at', '$today 00:00:00')
        .maybeSingle();

    if (existing != null) {
      throw Exception('Daily reward already claimed today');
    }

    // Award XP via direct insert (server-side trigger should update users.xp_total)
    const xpAmount = 50;

    await _supabase.from('xp_history').insert({
      'id': userId,
      'action_type': 'daily_reward',
      'xp_earned': xpAmount,
    });

    // Update user XP total
    await _supabase
        .rpc(
          'increment_user_xp',
          params: {'user_id': userId, 'xp_amount': xpAmount},
        )
        .catchError((e) async {
          // Fallback: direct update if RPC doesn't exist
          await _supabase
              .from('users')
              .update({
                'xp_total': _supabase.rpc(
                  'get_user_xp',
                  params: {'user_id': userId},
                ),
              })
              .eq('id', userId);
        });

    return xpAmount;
  }

  /// Check if daily reward is available
  Future<bool> isDailyRewardAvailable(String userId) async {
    final today = DateTime.now().toUtc().toIso8601String().split('T')[0];

    final existing = await _supabase
        .from('xp_history')
        .select('xp_id')
        .eq('id', userId)
        .eq('action_type', 'daily_reward')
        .gte('created_at', '$today 00:00:00')
        .maybeSingle();

    return existing == null;
  }

  /// Get roadmap rewards based on user level
  List<RoadmapReward> getRoadmapRewards(int currentLevel) {
    final rewards = [
      const RoadmapReward(
        name: 'Seedling',
        subtitle: 'Welcome Gift',
        iconName: 'eco',
        status: RewardStatus.unlocked,
        requiredLevel: 1,
      ),
      const RoadmapReward(
        name: 'Desert Rose',
        subtitle: 'Level 2 Reward',
        iconName: 'local_florist',
        status: RewardStatus.unlocked,
        requiredLevel: 2,
      ),
      const RoadmapReward(
        name: 'Date Palm',
        subtitle: 'Level 5 Reward',
        iconName: 'nature',
        status: RewardStatus.locked,
        requiredLevel: 5,
      ),
      const RoadmapReward(
        name: 'Olive Tree',
        subtitle: 'Level 10 Reward',
        iconName: 'park',
        status: RewardStatus.locked,
        requiredLevel: 10,
      ),
      const RoadmapReward(
        name: 'Atlas Cedar',
        subtitle: 'Level 20 Reward',
        iconName: 'forest',
        status: RewardStatus.locked,
        requiredLevel: 20,
      ),
    ];

    // Update status based on current level
    return rewards.map((reward) {
      if (reward.requiredLevel <= currentLevel) {
        return RoadmapReward(
          name: reward.name,
          subtitle: reward.subtitle,
          iconName: reward.iconName,
          status: RewardStatus.unlocked,
          requiredLevel: reward.requiredLevel,
        );
      } else if (reward.requiredLevel == currentLevel + 1) {
        final progress = ((currentLevel % 1) * 100).toInt();
        return RoadmapReward(
          name: reward.name,
          subtitle: 'Reach Level ${reward.requiredLevel}',
          iconName: reward.iconName,
          status: RewardStatus.current,
          progressPercent: progress,
          requiredLevel: reward.requiredLevel,
        );
      } else {
        return RoadmapReward(
          name: reward.name,
          subtitle: 'Locked • Reach Level ${reward.requiredLevel}',
          iconName: reward.iconName,
          status: RewardStatus.locked,
          requiredLevel: reward.requiredLevel,
        );
      }
    }).toList();
  }
}
