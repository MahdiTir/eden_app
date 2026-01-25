import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/quiz_models.dart';
import '../providers/quiz_provider.dart';

class QuizPage extends ConsumerStatefulWidget {
  const QuizPage({super.key});

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _bounceController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    // Shake animation for wrong answer
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);

    // Bounce animation for correct answer
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(
      begin: 1,
      end: 1.1,
    ).chain(CurveTween(curve: Curves.elasticOut)).animate(_bounceController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(quizQuestionsProvider);
    final session = ref.watch(quizSessionProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: questionsAsync.when(
          data: (questions) {
            // Start quiz if not already started
            if (session == null && questions.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(quizSessionProvider.notifier).startQuiz(questions);
              });
              return const Center(
                child: CircularProgressIndicator(color: AppColors.secondary),
              );
            }

            if (session == null || questions.isEmpty) {
              return _buildEmptyState();
            }

            return _QuizContent(
              session: session,
              shakeAnimation: _shakeAnimation,
              bounceAnimation: _bounceAnimation,
              onCorrect: () => _bounceController.forward().then(
                (_) => _bounceController.reverse(),
              ),
              onWrong: () => _shakeController.forward().then(
                (_) => _shakeController.reset(),
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.secondary),
          ),
          error: (err, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text('Failed to load quiz', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Text('$err', style: AppTextStyles.bodyMedium),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => ref.refresh(quizQuestionsProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.quiz_outlined, size: 80, color: AppColors.secondary),
          const SizedBox(height: 24),
          Text('No quiz questions available', style: AppTextStyles.h3),
          const SizedBox(height: 12),
          Text('Check back later!', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}

class _QuizContent extends ConsumerStatefulWidget {
  final QuizSession session;
  final Animation<double> shakeAnimation;
  final Animation<double> bounceAnimation;
  final VoidCallback onCorrect;
  final VoidCallback onWrong;

  const _QuizContent({
    required this.session,
    required this.shakeAnimation,
    required this.bounceAnimation,
    required this.onCorrect,
    required this.onWrong,
  });

  @override
  ConsumerState<_QuizContent> createState() => _QuizContentState();
}

class _QuizContentState extends ConsumerState<_QuizContent> {
  bool _isSubmitting = false;
  bool? _lastAnswerCorrect;

  void _selectOption(int index) {
    if (widget.session.hasAnswered) return;
    ref.read(quizSessionProvider.notifier).selectOption(index);
  }

  Future<void> _submitAnswer() async {
    if (widget.session.selectedOptionIndex == null ||
        widget.session.hasAnswered ||
        _isSubmitting) {
      return;
    }

    setState(() => _isSubmitting = true);

    final isCorrect = await ref
        .read(quizSessionProvider.notifier)
        .submitAnswer();

    setState(() {
      _isSubmitting = false;
      _lastAnswerCorrect = isCorrect;
    });

    if (isCorrect) {
      widget.onCorrect();
    } else {
      widget.onWrong();
    }

    // Show feedback
    if (mounted) {
      _showAnswerFeedback(isCorrect);
    }
  }

  void _showAnswerFeedback(bool isCorrect) {
    final session = widget.session;
    final xpEarned = isCorrect
        ? (50 + (session.streak >= 3 ? 20 : 0) + (session.streak >= 5 ? 30 : 0))
        : 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => _AnswerFeedbackSheet(
        isCorrect: isCorrect,
        xpEarned: xpEarned,
        streak: session.streak,
        onContinue: () {
          context.pop();
          if (session.isLastQuestion) {
            _showResults();
          } else {
            ref.read(quizSessionProvider.notifier).nextQuestion();
          }
        },
      ),
    );
  }

  Future<void> _showResults() async {
    try {
      final result = await ref
          .read(quizSessionProvider.notifier)
          .completeQuiz();

      if (mounted) {
        context.pushReplacement('/quiz/results', extra: result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error completing quiz: $e')));
      }
    }
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Quit Quiz?'),
        content: const Text('Your progress will be lost if you exit now.'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Continue',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.pop();
              ref.read(quizSessionProvider.notifier).reset();
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Quit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    final question = session.currentQuestion;
    final user = ref.watch(currentUserProvider);

    return Column(
      children: [
        // App Bar
        _buildAppBar(session.streak),

        // Progress Section
        _buildProgressSection(session),

        // Question Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Question Text
                Text(
                  'Identify this plant',
                  style: AppTextStyles.h2,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Question Image
                _buildQuestionImage(question),

                const SizedBox(height: 12),

                // Hint Text
                if (question.hint != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      question.hint!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 24),

                // Answer Options
                ...List.generate(
                  question.options.length,
                  (index) => _buildOption(
                    question,
                    index,
                    session.hasAnswered,
                    session.selectedOptionIndex,
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),

        // Bottom Submit Button
        _buildSubmitButton(session, user != null),
      ],
    );
  }

  Widget _buildAppBar(int streak) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: _showExitConfirmation,
            icon: const Icon(Icons.arrow_back_ios_new),
            color: AppColors.textPrimary,
          ),
          Expanded(
            child: Text(
              'Quiz Challenge',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          if (streak > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    size: 16,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$streak',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildProgressSection(QuizSession session) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'QUESTION ${session.currentIndex + 1}/${session.questions.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                  letterSpacing: 1.2,
                ),
              ),
              AnimatedBuilder(
                animation: widget.bounceAnimation,
                builder: (context, child) => Transform.scale(
                  scale: widget.bounceAnimation.value,
                  child: child,
                ),
                child: Row(
                  children: [
                    Icon(Icons.stars, size: 16, color: Colors.amber.shade600),
                    const SizedBox(width: 4),
                    Text(
                      'Score: ${session.score}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: session.progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionImage(QuizQuestion question) {
    return AnimatedBuilder(
      animation: widget.shakeAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(
          widget.shakeAnimation.value *
              (widget.session.hasAnswered && _lastAnswerCorrect == false
                  ? 1
                  : 0),
          0,
        ),
        child: child,
      ),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (question.imageUrl.isNotEmpty)
                Image.network(
                  question.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: AppColors.accent,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          color: AppColors.secondary,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    // Use mock assets as fallbacks if network fails
                    final mockAssets = [
                      'assets/images/oleander.png',
                      'assets/images/olive_tree.png',
                      'assets/images/mentha.png',
                      'assets/images/deglet_nour.png',
                      'assets/images/barbary_fig.png',
                      'assets/images/atlas_cedar.png',
                      'assets/images/lavender.jpg',
                      'assets/images/rosemary.jpg',
                      'assets/images/hibiscus.jpg',
                      'assets/images/jasmine.jpg',
                    ];
                    // Use questionId hash or similar to pick a stable mock image for this question session
                    final assetIndex =
                        question.questionId.hashCode.abs() % mockAssets.length;
                    return Image.asset(
                      mockAssets[assetIndex],
                      fit: BoxFit.cover,
                    );
                  },
                )
              else
                Image.asset(
                  // Use a default mock image
                  'assets/images/oleander.png',
                  fit: BoxFit.cover,
                ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.2),
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

  Widget _buildOption(
    QuizQuestion question,
    int index,
    bool hasAnswered,
    int? selectedOptionIndex,
  ) {
    final option = question.options[index];
    final isSelected = selectedOptionIndex == index;
    final isCorrectOption = option.plantId == question.correctPlantId;

    Color borderColor = Colors.grey.shade200;
    Color backgroundColor = Colors.white;
    Color radioColor = Colors.grey.shade300;

    if (hasAnswered) {
      if (isCorrectOption) {
        borderColor = AppColors.secondary;
        backgroundColor = AppColors.secondary.withValues(alpha: 0.1);
        radioColor = AppColors.secondary;
      } else if (isSelected && !isCorrectOption) {
        borderColor = AppColors.error;
        backgroundColor = AppColors.error.withValues(alpha: 0.05);
        radioColor = AppColors.error;
      }
    } else if (isSelected) {
      borderColor = AppColors.secondary;
      backgroundColor = AppColors.secondary.withValues(alpha: 0.05);
      radioColor = AppColors.secondary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => _selectOption(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Radio circle
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: radioColor, width: 2),
                  color: isSelected || (hasAnswered && isCorrectOption)
                      ? radioColor
                      : Colors.transparent,
                ),
                child: isSelected || (hasAnswered && isCorrectOption)
                    ? Icon(
                        hasAnswered
                            ? (isCorrectOption ? Icons.check : Icons.close)
                            : Icons.circle,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.scientificName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      option.commonName,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasAnswered && (isSelected || isCorrectOption))
                Icon(
                  isCorrectOption ? Icons.check_circle : Icons.cancel,
                  color: isCorrectOption
                      ? AppColors.secondary
                      : AppColors.error,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(QuizSession session, bool isAuthenticated) {
    final canSubmit =
        session.selectedOptionIndex != null &&
        !session.hasAnswered &&
        !_isSubmitting;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isAuthenticated)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Sign in to save your progress and earn XP',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canSubmit ? _submitAnswer : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canSubmit
                      ? AppColors.secondary
                      : Colors.grey.shade300,
                  foregroundColor: canSubmit
                      ? Colors.white
                      : Colors.grey.shade500,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: canSubmit ? 4 : 0,
                  shadowColor: AppColors.secondary.withValues(alpha: 0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isSubmitting ? 'Submitting...' : 'Submit Answer',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!_isSubmitting) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 20),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Answer Feedback Bottom Sheet
class _AnswerFeedbackSheet extends StatelessWidget {
  final bool isCorrect;
  final int xpEarned;
  final int streak;
  final VoidCallback onContinue;

  const _AnswerFeedbackSheet({
    required this.isCorrect,
    required this.xpEarned,
    required this.streak,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppColors.secondary.withValues(alpha: 0.95)
            : AppColors.error.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isCorrect ? 'Correct! 🎉' : 'Not quite right',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          if (isCorrect) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.stars, color: Colors.amber, size: 24),
                const SizedBox(width: 8),
                Text(
                  '+$xpEarned XP',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (streak >= 3) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$streak Streak!',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: isCorrect
                    ? AppColors.primary
                    : AppColors.error,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
