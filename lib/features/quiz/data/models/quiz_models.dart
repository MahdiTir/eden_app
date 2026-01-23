import 'package:equatable/equatable.dart';

/// A plant option for quiz answers
class PlantOption extends Equatable {
  final String plantId;
  final String scientificName;
  final String commonName;

  const PlantOption({
    required this.plantId,
    required this.scientificName,
    required this.commonName,
  });

  factory PlantOption.fromJson(Map<String, dynamic> json) {
    return PlantOption(
      plantId: json['plant_id'].toString(),
      scientificName: json['scientific_name'] as String? ?? '',
      commonName: json['common_name'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [plantId, scientificName, commonName];
}

/// A quiz question with image and options
class QuizQuestion extends Equatable {
  final String questionId;
  final String? quizId;
  final String imageUrl;
  final String correctPlantId;
  final List<PlantOption> options;
  final String? hint;

  const QuizQuestion({
    required this.questionId,
    this.quizId,
    required this.imageUrl,
    required this.correctPlantId,
    required this.options,
    this.hint,
  });

  /// Index of the correct answer in options list
  int get correctIndex =>
      options.indexWhere((o) => o.plantId == correctPlantId);

  @override
  List<Object?> get props => [
    questionId,
    quizId,
    imageUrl,
    correctPlantId,
    options,
    hint,
  ];
}

/// Result of a completed quiz session
class QuizResult extends Equatable {
  final int totalQuestions;
  final int correctAnswers;
  final int totalXpEarned;
  final int maxStreak;
  final Duration timeTaken;

  const QuizResult({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.totalXpEarned,
    required this.maxStreak,
    required this.timeTaken,
  });

  double get accuracy =>
      totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0;

  @override
  List<Object?> get props => [
    totalQuestions,
    correctAnswers,
    totalXpEarned,
    maxStreak,
    timeTaken,
  ];
}

/// Local state for current quiz session
class QuizSession {
  final List<QuizQuestion> questions;
  int currentIndex;
  int? selectedOptionIndex;
  bool hasAnswered;
  int score;
  int correctCount;
  int streak;
  int maxStreak;
  DateTime startTime;
  List<bool> answers;

  QuizSession({
    required this.questions,
    this.currentIndex = 0,
    this.selectedOptionIndex,
    this.hasAnswered = false,
    this.score = 0,
    this.correctCount = 0,
    this.streak = 0,
    this.maxStreak = 0,
    DateTime? startTime,
    List<bool>? answers,
  }) : startTime = startTime ?? DateTime.now(),
       answers = answers ?? [];

  QuizQuestion get currentQuestion => questions[currentIndex];
  double get progress => (currentIndex + 1) / questions.length;
  bool get isLastQuestion => currentIndex >= questions.length - 1;

  QuizSession copyWith({
    List<QuizQuestion>? questions,
    int? currentIndex,
    int? selectedOptionIndex,
    bool? hasAnswered,
    int? score,
    int? correctCount,
    int? streak,
    int? maxStreak,
    DateTime? startTime,
    List<bool>? answers,
  }) {
    return QuizSession(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedOptionIndex: selectedOptionIndex,
      hasAnswered: hasAnswered ?? this.hasAnswered,
      score: score ?? this.score,
      correctCount: correctCount ?? this.correctCount,
      streak: streak ?? this.streak,
      maxStreak: maxStreak ?? this.maxStreak,
      startTime: startTime ?? this.startTime,
      answers: answers ?? this.answers,
    );
  }

  QuizResult toResult() {
    return QuizResult(
      totalQuestions: questions.length,
      correctAnswers: correctCount,
      totalXpEarned: score,
      maxStreak: maxStreak,
      timeTaken: DateTime.now().difference(startTime),
    );
  }
}
