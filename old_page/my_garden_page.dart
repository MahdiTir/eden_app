import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'upload_page.dart';

/// Model for user stats
class GardenStats {
  final int level;
  final String levelTitle;
  final int xp;
  final int seeds;
  final int progressPercent;
  final int xpToNextLevel;

  const GardenStats({
    required this.level,
    required this.levelTitle,
    required this.xp,
    required this.seeds,
    required this.progressPercent,
    required this.xpToNextLevel,
  });
}

/// Model for roadmap rewards
class RoadmapReward {
  final String name;
  final String subtitle;
  final IconData icon;
  final RewardStatus status;
  final int? progressPercent;

  const RoadmapReward({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.status,
    this.progressPercent,
  });
}

enum RewardStatus {
  unlocked,
  current,
  locked,
}

class MyGardenPage extends StatefulWidget {
  final GardenStats? stats;
  final List<RoadmapReward>? rewards;

  const MyGardenPage({super.key, this.stats, this.rewards});

  @override
  State<MyGardenPage> createState() => _MyGardenPageState();
}

class _MyGardenPageState extends State<MyGardenPage> {
  late GardenStats _stats;
  late List<RoadmapReward> _rewards;
  bool _isDailyRewardClaimed = false;

  @override
  void initState() {
    super.initState();
    _stats = widget.stats ?? _getSampleStats();
    _rewards = widget.rewards ?? _getSampleRewards();
  }

  GardenStats _getSampleStats() {
    return const GardenStats(
      level: 3,
      levelTitle: 'Novice',
      xp: 1250,
      seeds: 340,
      progressPercent: 60,
      xpToNextLevel: 800,
    );
  }

  List<RoadmapReward> _getSampleRewards() {
    return const [
      RoadmapReward(
        name: 'Seedling',
        subtitle: 'Starter Gift',
        icon: Icons.eco,
        status: RewardStatus.unlocked,
      ),
      RoadmapReward(
        name: 'Desert Rose',
        subtitle: 'Level 2 Reward',
        icon: Icons.local_florist,
        status: RewardStatus.unlocked,
      ),
      RoadmapReward(
        name: 'Apple Tree Sapling',
        subtitle: 'Locked • Reach Level 5',
        icon: Icons.nature,
        status: RewardStatus.current,
        progressPercent: 20,
      ),
      RoadmapReward(
        name: 'Royal Ananas',
        subtitle: 'Locked • Identify 50 Plants',
        icon: Icons.forest,
        status: RewardStatus.locked,
      ),
      RoadmapReward(
        name: 'Atlas Cedar',
        subtitle: 'Locked • Rare Find',
        icon: Icons.shield_moon,
        status: RewardStatus.locked,
      ),
    ];
  }

  void _claimDailyReward() {
    if (_isDailyRewardClaimed) return;

    setState(() {
      _isDailyRewardClaimed = true;
    });

    // Show reward dialog
    showDialog(
      context: context,
      builder: (context) => _DailyRewardDialog(
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _navigateToUpload() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UploadPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                backgroundColor: AppColors.backgroundLight,
                elevation: 0,
                pinned: true,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new),
                  color: AppColors.textMainLight,
                ),
                centerTitle: true,
                title: Text(
                  'My Garden Journey',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMainLight,
                  ),
                ),
                actions: [
                  // Upload button (instead of Help)
                  IconButton(
                    onPressed: _navigateToUpload,
                    icon: const Icon(Icons.cloud_upload_outlined),
                    color: AppColors.primary,
                    tooltip: 'Upload Plant',
                  ),
                ],
              ),

              // Stats Section
              SliverToBoxAdapter(
                child: _buildStatsSection(),
              ),

              // Progress Bar
              SliverToBoxAdapter(
                child: _buildProgressCard(),
              ),

              // Roadmap Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Text(
                    'Your Path',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMainLight,
                    ),
                  ),
                ),
              ),

              // Roadmap Timeline
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildRoadmapItem(_rewards[index], index),
                  childCount: _rewards.length,
                ),
              ),

              // Bottom spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),

          // Fixed Bottom Button
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: _buildClaimButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildStatCard(
            'Lvl ${_stats.level}',
            _stats.levelTitle,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            _formatNumber(_stats.xp),
            'XP',
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            _formatNumber(_stats.seeds),
            'Seeds',
          ),
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
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textMainLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSubLight,
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
                  'Progress to Level ${_stats.level + 1}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMainLight,
                  ),
                ),
                Text(
                  '${_stats.progressPercent}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: _stats.progressPercent / 100,
                minHeight: 12,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Earn ${_stats.xpToNextLevel} more XP to level up',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSubLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoadmapItem(RoadmapReward reward, int index) {
    final isFirst = index == 0;
    final isLast = index == _rewards.length - 1;
    final isUnlocked = reward.status == RewardStatus.unlocked;
    final isCurrent = reward.status == RewardStatus.current;
    
    double opacity = 1.0;
    if (reward.status == RewardStatus.locked) {
      opacity = 0.6 - (index - 3) * 0.15;
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
                    // Top line
                    if (!isFirst)
                      Container(
                        width: isUnlocked || isCurrent ? 4 : 2,
                        height: 16,
                        decoration: BoxDecoration(
                          color: isUnlocked || isCurrent
                              ? AppColors.primary
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    
                    // Icon circle
                    _buildTimelineIcon(reward),
                    
                    // Bottom line
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: isUnlocked ? 4 : 2,
                          decoration: BoxDecoration(
                            color: isUnlocked
                                ? AppColors.primary
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Content card
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

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isUnlocked || isCurrent
            ? AppColors.primary
            : Colors.white,
        border: isUnlocked || isCurrent
            ? null
            : Border.all(color: Colors.grey.shade300, width: 2),
        boxShadow: isUnlocked || isCurrent
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Icon(
        reward.icon,
        size: 28,
        color: isUnlocked || isCurrent
            ? AppColors.backgroundDark
            : Colors.grey.shade400,
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
              ? AppColors.primary.withOpacity(0.3)
              : Colors.grey.shade200,
          style: isLocked ? BorderStyle.solid : BorderStyle.solid,
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
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMainLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reward.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSubLight,
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
                    color: AppColors.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 20,
                    color: AppColors.primary,
                  ),
                )
              else if (isLocked || isCurrent)
                Icon(
                  Icons.lock,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
          
          // Progress bar for current reward
          if (isCurrent && reward.progressPercent != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: reward.progressPercent! / 100,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primary.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${reward.progressPercent}% Complete',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildClaimButton() {
    return SafeArea(
      child: ElevatedButton(
        onPressed: _isDailyRewardClaimed ? null : _claimDailyReward,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isDailyRewardClaimed
              ? Colors.grey.shade400
              : AppColors.primary,
          foregroundColor: AppColors.textMainLight,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: _isDailyRewardClaimed ? 0 : 4,
          shadowColor: AppColors.primary.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isDailyRewardClaimed ? Icons.check : Icons.card_giftcard,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              _isDailyRewardClaimed ? 'Reward Claimed!' : 'Claim Daily Reward',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
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

/// Daily Reward Dialog
class _DailyRewardDialog extends StatelessWidget {
  final VoidCallback onClose;

  const _DailyRewardDialog({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gift icon with animation
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.card_giftcard,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              '🎉 Daily Reward!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 12),
            
            Text(
              'You received:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Rewards
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRewardItem(Icons.stars, '+50 XP', Colors.amber),
                const SizedBox(width: 24),
                _buildRewardItem(Icons.eco, '+10 Seeds', AppColors.primary),
              ],
            ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textMainLight,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Awesome!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
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
}
