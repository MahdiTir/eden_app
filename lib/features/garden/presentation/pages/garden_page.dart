import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/garden_models.dart';
import '../providers/garden_provider.dart';

class GardenPage extends ConsumerWidget {
  const GardenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    // Redirect to login if not authenticated
    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios_new),
            color: AppColors.textPrimary,
          ),
          title: Text('My Garden', style: AppTextStyles.h2),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.eco, size: 80, color: AppColors.secondary),
                const SizedBox(height: 24),
                Text(
                  'Sign in to access your garden',
                  style: AppTextStyles.h3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Track your XP, unlock plants, and grow your collection!',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => context.push('/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final gardenAsync = ref.watch(userGardenProvider);
    final rewards = ref.watch(roadmapRewardsProvider);
    final dailyRewardAsync = ref.watch(dailyRewardAvailableProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: gardenAsync.when(
        data: (garden) => garden == null
            ? const Center(child: Text('Unable to load garden'))
            : _GardenContent(
                garden: garden,
                rewards: rewards,
                isDailyRewardAvailable: dailyRewardAsync.value ?? false,
              ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.secondary),
        ),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _GardenContent extends ConsumerStatefulWidget {
  final UserGarden garden;
  final List<RoadmapReward> rewards;
  final bool isDailyRewardAvailable;

  const _GardenContent({
    required this.garden,
    required this.rewards,
    required this.isDailyRewardAvailable,
  });

  @override
  ConsumerState<_GardenContent> createState() => _GardenContentState();
}

class _GardenContentState extends ConsumerState<_GardenContent> {
  bool _isClaimingReward = false;

  void _claimDailyReward() async {
    if (_isClaimingReward || !widget.isDailyRewardAvailable) return;

    setState(() => _isClaimingReward = true);

    try {
      await ref.read(dailyRewardNotifierProvider.notifier).claimReward();
      ref.invalidate(userGardenProvider);
      ref.invalidate(dailyRewardAvailableProvider);

      if (mounted) {
        _showRewardDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to claim reward: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isClaimingReward = false);
      }
    }
  }

  void _showRewardDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.card_giftcard,
                  size: 40,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 20),
              Text('🎉 Daily Reward!', style: AppTextStyles.h2),
              const SizedBox(height: 12),
              Text('You received:', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRewardItem(Icons.stars, '+50 XP', Colors.amber),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Awesome!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardItem(IconData icon, String text, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              pinned: true,
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios_new),
                color: AppColors.textPrimary,
              ),
              centerTitle: true,
              title: Text(
                'My Garden Journey',
                style: AppTextStyles.h2.copyWith(fontSize: 18),
              ),
              actions: [
                IconButton(
                  onPressed: () => context.push('/scan'),
                  icon: const Icon(Icons.cloud_upload_outlined),
                  color: AppColors.secondary,
                  tooltip: 'Scan Plant',
                ),
              ],
            ),

            // Stats Section
            SliverToBoxAdapter(child: _buildStatsSection()),

            // Progress Bar
            SliverToBoxAdapter(child: _buildProgressCard()),

            // Roadmap Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Text('Your Path', style: AppTextStyles.h3),
              ),
            ),

            // Roadmap Timeline
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    _buildRoadmapItem(widget.rewards[index], index),
                childCount: widget.rewards.length,
              ),
            ),

            // Unlocked Plants Section
            if (widget.garden.plants.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Text(
                    'Your Plants (${widget.garden.plants.length})',
                    style: AppTextStyles.h3,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _buildPlantCard(widget.garden.plants[index]),
                    childCount: widget.garden.plants.length,
                  ),
                ),
              ),
            ],

            // Bottom spacing
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),

        // Fixed Bottom Button
        Positioned(left: 16, right: 16, bottom: 24, child: _buildClaimButton()),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildStatCard(
            'Lvl ${widget.garden.level}',
            widget.garden.levelTitle,
          ),
          const SizedBox(width: 12),
          _buildStatCard(_formatNumber(widget.garden.xpTotal), 'XP'),
          const SizedBox(width: 12),
          _buildStatCard('${widget.garden.plants.length}', 'Plants'),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.h3.copyWith(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress to Level ${widget.garden.level + 1}',
                  style: AppTextStyles.bodyMedium,
                ),
                Text(
                  '${widget.garden.progressPercent}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: widget.garden.progressPercent / 100,
                minHeight: 12,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.secondary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Earn ${widget.garden.xpToNextLevel} more XP to level up',
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoadmapItem(RoadmapReward reward, int index) {
    final isFirst = index == 0;
    final isLast = index == widget.rewards.length - 1;
    final isUnlocked = reward.status == RewardStatus.unlocked;
    final isCurrent = reward.status == RewardStatus.current;

    double opacity = 1.0;
    if (reward.status == RewardStatus.locked) {
      opacity = 0.6 - (index - 3) * 0.1;
      if (opacity < 0.4) opacity = 0.4;
    }

    return Opacity(
      opacity: opacity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline column
              SizedBox(
                width: 56,
                child: Column(
                  children: [
                    if (!isFirst)
                      Container(
                        width: isUnlocked || isCurrent ? 4 : 2,
                        height: 16,
                        decoration: BoxDecoration(
                          color: isUnlocked || isCurrent
                              ? AppColors.secondary
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    _buildTimelineIcon(reward),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: isUnlocked ? 4 : 2,
                          decoration: BoxDecoration(
                            color: isUnlocked
                                ? AppColors.secondary
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildRewardCard(reward),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineIcon(RoadmapReward reward) {
    final isUnlocked = reward.status == RewardStatus.unlocked;
    final isCurrent = reward.status == RewardStatus.current;

    IconData icon;
    switch (reward.iconName) {
      case 'eco':
        icon = Icons.eco;
        break;
      case 'local_florist':
        icon = Icons.local_florist;
        break;
      case 'nature':
        icon = Icons.nature;
        break;
      case 'park':
        icon = Icons.park;
        break;
      case 'forest':
        icon = Icons.forest;
        break;
      default:
        icon = Icons.emoji_events;
    }

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isUnlocked || isCurrent ? AppColors.secondary : Colors.white,
        border: isUnlocked || isCurrent
            ? null
            : Border.all(color: Colors.grey.shade300, width: 2),
        boxShadow: isUnlocked || isCurrent
            ? [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Icon(
        icon,
        size: 28,
        color: isUnlocked || isCurrent ? Colors.white : Colors.grey.shade400,
      ),
    );
  }

  Widget _buildRewardCard(RoadmapReward reward) {
    final isUnlocked = reward.status == RewardStatus.unlocked;
    final isCurrent = reward.status == RewardStatus.current;
    final isLocked = reward.status == RewardStatus.locked;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrent
              ? AppColors.secondary.withOpacity(0.3)
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reward.name,
                      style: AppTextStyles.h3.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reward.subtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isUnlocked)
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 20,
                    color: AppColors.secondary,
                  ),
                )
              else if (isLocked || isCurrent)
                Icon(Icons.lock, size: 20, color: Colors.grey.shade400),
            ],
          ),
          if (isCurrent && reward.progressPercent != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: reward.progressPercent! / 100,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.secondary.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${reward.progressPercent}% Complete',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlantCard(GardenPlant plant) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                image: plant.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(plant.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: plant.imageUrl == null
                  ? const Center(
                      child: Icon(
                        Icons.eco,
                        size: 40,
                        color: AppColors.secondary,
                      ),
                    )
                  : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plant.commonName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  plant.scientificName,
                  style: TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClaimButton() {
    final canClaim = widget.isDailyRewardAvailable && !_isClaimingReward;

    return SafeArea(
      child: ElevatedButton(
        onPressed: canClaim ? _claimDailyReward : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canClaim
              ? AppColors.secondary
              : Colors.grey.shade400,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: canClaim ? 4 : 0,
          shadowColor: AppColors.secondary.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isClaimingReward
                  ? Icons.hourglass_top
                  : (!widget.isDailyRewardAvailable
                        ? Icons.check
                        : Icons.card_giftcard),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              _isClaimingReward
                  ? 'Claiming...'
                  : (!widget.isDailyRewardAvailable
                        ? 'Reward Claimed!'
                        : 'Claim Daily Reward'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(number % 1000 == 0 ? 0 : 1)}K';
    }
    return number.toString();
  }
}
