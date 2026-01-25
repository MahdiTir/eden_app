import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../data/models/quiz_models.dart';
import '../../data/repositories/quiz_repository.dart';

/// Provider for quiz repository
final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return QuizRepository(supabase);
});

/// Provider for loading quiz questions
final quizQuestionsProvider = FutureProvider.autoDispose<List<QuizQuestion>>((
  ref,
) async {
  final repository = ref.watch(quizRepositoryProvider);
  return repository.getQuizQuestions(limit: 5);
});

/// State notifier for managing quiz session
class QuizSessionNotifier extends Notifier<QuizSession?> {
  @override
  QuizSession? build() => null;

  /// Start a new quiz session with questions
  void startQuiz(List<QuizQuestion> questions) {
    state = QuizSession(questions: questions);
  }

  /// Select an answer option
  void selectOption(int index) {
    if (state == null || state!.hasAnswered) return;
    state = state!.copyWith(selectedOptionIndex: index);
  }

  /// Submit the selected answer
  Future<bool> submitAnswer() async {
    if (state == null ||
        state!.selectedOptionIndex == null ||
        state!.hasAnswered) {
      return false;
    }

    final session = state!;
    final question = session.currentQuestion;
    final selectedIndex = session.selectedOptionIndex!;
    final selectedOption = question.options[selectedIndex];
    final isCorrect = selectedOption.plantId == question.correctPlantId;

    // Calculate XP
    int xpEarned = 0;
    int newStreak = session.streak;
    int newMaxStreak = session.maxStreak;
    int newCorrectCount = session.correctCount;

    if (isCorrect) {
      newCorrectCount++;
      newStreak++;
      if (newStreak > newMaxStreak) newMaxStreak = newStreak;

      // Base XP + streak bonuses
      xpEarned = 50;
      if (newStreak >= 3) xpEarned += 20;
      if (newStreak >= 5) xpEarned += 30;
    } else {
      newStreak = 0;
    }

    // Submit answer to database if user is authenticated
    final user = ref.read(currentUserProvider);
    if (user != null) {
      final repository = ref.read(quizRepositoryProvider);
      try {
        await repository.submitAnswer(
          userId: user.id,
          questionId: question.questionId,
          selectedPlantId: selectedOption.plantId,
          isCorrect: isCorrect,
        );
      } catch (e) {
        // Log error but don't fail the quiz
        // ignore: avoid_print
        print('Failed to submit answer: $e');
      }
    }

    // Update state
    final newAnswers = List<bool>.from(session.answers)..add(isCorrect);
    state = session.copyWith(
      hasAnswered: true,
      score: session.score + xpEarned,
      correctCount: newCorrectCount,
      streak: newStreak,
      maxStreak: newMaxStreak,
      answers: newAnswers,
    );

    return isCorrect;
  }

  /// Move to next question
  void nextQuestion() {
    if (state == null) return;
    state = state!.copyWith(
      currentIndex: state!.currentIndex + 1,
      selectedOptionIndex: null,
      hasAnswered: false,
    );
  }

  /// Complete quiz and award XP
  Future<QuizResult> completeQuiz() async {
    if (state == null) {
      throw Exception('No active quiz session');
    }

    final result = state!.toResult();
    final user = ref.read(currentUserProvider);

    // Award XP to user if authenticated
    if (user != null && result.correctAnswers > 0) {
      final repository = ref.read(quizRepositoryProvider);
      try {
        await repository.awardQuizXp(
          userId: user.id,
          correctAnswers: result.correctAnswers,
          totalQuestions: result.totalQuestions,
        );

        // Also save the summary/attempt
        await repository.saveQuizSummary(userId: user.id, result: result);
      } catch (e) {
        // Log error but still return result
        // ignore: avoid_print
        print('Failed to save quiz results: $e');
      }
    }

    return result;
  }

  /// Reset quiz state
  void reset() {
    state = null;
  }
}

/// Provider for quiz session management
final quizSessionProvider =
    NotifierProvider.autoDispose<QuizSessionNotifier, QuizSession?>(
      QuizSessionNotifier.new,
    );

/// Provider to get current streak for display
final currentStreakProvider = Provider.autoDispose<int>((ref) {
  final session = ref.watch(quizSessionProvider);
  return session?.streak ?? 0;
});

/// Provider to get current score for display
final currentScoreProvider = Provider.autoDispose<int>((ref) {
  final session = ref.watch(quizSessionProvider);
  return session?.score ?? 0;
});
