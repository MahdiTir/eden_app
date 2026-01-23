import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/quiz_models.dart';

class QuizResultsPage extends StatelessWidget {
  final QuizResult result;

  const QuizResultsPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isPerfect = result.correctAnswers == result.totalQuestions;
    final isGood = result.accuracy >= 70;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              // Trophy/Result icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: isPerfect
                      ? Colors.amber.shade100
                      : isGood
                      ? AppColors.accent
                      : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPerfect
                      ? Icons.emoji_events
                      : isGood
                      ? Icons.celebration
                      : Icons.sentiment_satisfied,
                  size: 64,
                  color: isPerfect
                      ? Colors.amber.shade700
                      : isGood
                      ? AppColors.secondary
                      : Colors.grey.shade500,
                ),
              ),

              const SizedBox(height: 24),

              // Title
              Text(
                isPerfect
                    ? 'Perfect Score! 🏆'
                    : isGood
                    ? 'Great Job! 🌟'
                    : 'Keep Learning! 📚',
                style: AppTextStyles.h2.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'You completed the quiz!',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 32),

              // Stats Grid
              Row(
                children: [
                  _buildStatCard(
                    icon: Icons.check_circle,
                    iconColor: AppColors.secondary,
                    value: '${result.correctAnswers}/${result.totalQuestions}',
                    label: 'Correct',
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    icon: Icons.percent,
                    iconColor: Colors.blue,
                    value: '${result.accuracy.toStringAsFixed(0)}%',
                    label: 'Accuracy',
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  _buildStatCard(
                    icon: Icons.stars,
                    iconColor: Colors.amber.shade600,
                    value: '+${result.totalXpEarned}',
                    label: 'XP Earned',
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    icon: Icons.local_fire_department,
                    iconColor: Colors.orange,
                    value: '${result.maxStreak}',
                    label: 'Best Streak',
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Time taken
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timer_outlined, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      'Time: ${_formatDuration(result.timeTaken)}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Action buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/quiz');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: AppColors.secondary.withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Play Again',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/home'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home_outlined, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Back to Home',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }
}
