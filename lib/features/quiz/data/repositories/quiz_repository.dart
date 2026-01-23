import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/quiz_models.dart';

/// Repository for quiz-related Supabase operations
class QuizRepository {
  final SupabaseClient _supabase;

  QuizRepository(this._supabase);

  /// Fetch quiz questions with plant options
  Future<List<QuizQuestion>> getQuizQuestions({int limit = 5}) async {
    // Fetch random quiz questions with their images and correct plant
    final questionsResult = await _supabase
        .from('quiz_questions')
        .select('''
          question_id,
          quiz_id,
          correct_plant_id,
          plant_dataset_images!dataset_image_id (
            image_url,
            plant_id
          )
        ''')
        .limit(limit);

    final questions = <QuizQuestion>[];

    for (final q in questionsResult as List) {
      final questionId = q['question_id'].toString();
      final correctPlantId = q['correct_plant_id'].toString();
      final datasetImage = q['plant_dataset_images'] as Map<String, dynamic>?;
      final imageUrl = datasetImage?['image_url'] as String? ?? '';

      // Fetch 5 random plant options including the correct one
      final plantsResult = await _supabase
          .from('plants')
          .select('plant_id, scientific_name, common_name')
          .limit(10);

      // Make sure correct plant is included
      var options = (plantsResult as List)
          .map((p) => PlantOption.fromJson(p as Map<String, dynamic>))
          .toList();

      // Ensure correct plant is in options
      final hasCorrect = options.any((o) => o.plantId == correctPlantId);
      if (!hasCorrect) {
        final correctPlantResult = await _supabase
            .from('plants')
            .select('plant_id, scientific_name, common_name')
            .eq('plant_id', correctPlantId)
            .single();
        options.insert(0, PlantOption.fromJson(correctPlantResult));
      }

      // Take only 5 options and shuffle
      options.shuffle();
      if (options.length > 5) {
        // Make sure correct answer is kept
        final correctOption = options.firstWhere(
          (o) => o.plantId == correctPlantId,
        );
        options = options
            .where((o) => o.plantId != correctPlantId)
            .take(4)
            .toList();
        options.add(correctOption);
        options.shuffle();
      }

      questions.add(
        QuizQuestion(
          questionId: questionId,
          quizId: q['quiz_id']?.toString(),
          imageUrl: imageUrl,
          correctPlantId: correctPlantId,
          options: options,
          hint: 'Identify this plant species',
        ),
      );
    }

    return questions;
  }

  /// Submit a quiz answer to the database
  Future<void> submitAnswer({
    required String userId,
    required String questionId,
    required String selectedPlantId,
    required bool isCorrect,
  }) async {
    await _supabase.from('quiz_responses').insert({
      'user_id': userId,
      'question_id': questionId,
      'selected_plant_id': selectedPlantId,
      'is_correct': isCorrect,
    });
  }

  /// Award XP for quiz completion (calls server-side logic)
  Future<void> awardQuizXp({
    required String userId,
    required int correctAnswers,
    required int totalQuestions,
  }) async {
    // XP calculation: 50 XP per correct answer
    final xpAmount = correctAnswers * 50;

    if (xpAmount <= 0) return;

    // Insert XP history record
    await _supabase.from('xp_history').insert({
      'id': userId,
      'action_type': 'quiz_completion',
      'xp_earned': xpAmount,
    });

    // Try to call RPC for XP update, fallback to direct update if RPC doesn't exist
    try {
      await _supabase.rpc(
        'increment_user_xp',
        params: {'user_id': userId, 'xp_amount': xpAmount},
      );
    } catch (e) {
      // Fallback: fetch current XP and update
      final userResult = await _supabase
          .from('users')
          .select('xp_total')
          .eq('id', userId)
          .single();

      final currentXp = (userResult['xp_total'] as num?)?.toInt() ?? 0;

      await _supabase
          .from('users')
          .update({'xp_total': currentXp + xpAmount})
          .eq('id', userId);
    }
  }

  /// Get user's quiz history
  Future<List<Map<String, dynamic>>> getQuizHistory(String userId) async {
    final result = await _supabase
        .from('quiz_responses')
        .select('''
          response_id,
          question_id,
          is_correct,
          response_date,
          plants!selected_plant_id (
            scientific_name,
            common_name
          )
        ''')
        .eq('user_id', userId)
        .order('response_date', ascending: false)
        .limit(50);

    return List<Map<String, dynamic>>.from(result as List);
  }
}
