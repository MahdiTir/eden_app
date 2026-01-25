import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/quiz_models.dart';

/// Repository for quiz-related Supabase operations
class QuizRepository {
  final SupabaseClient _supabase;

  QuizRepository(this._supabase);

  /// Fetch quiz questions with plant options
  Future<List<QuizQuestion>> getQuizQuestions({int limit = 5}) async {
    // 1. Fetch random quiz questions with their images and correct plant
    // Note: To get true random, an RPC or custom query is better,
    // but we'll stick to a basic selection for now.
    final questionsResult = await _supabase
        .from('quiz_questions')
        .select('''
          *,
          plant_dataset_images (
            *
          )
        ''')
        .limit(limit);

    final questionsData = questionsResult as List;
    if (questionsData.isEmpty) {
      return [];
    }

    // 2. Fetch a pool of plants to use as wrong options (efficient: fetch once)
    final plantsResult = await _supabase
        .from('plants')
        .select('plant_id, scientific_name, common_name')
        .limit(50); // Get a good pool

    final allPlantsPool = (plantsResult as List)
        .map((p) => PlantOption.fromJson(p as Map<String, dynamic>))
        .toList();

    final questions = <QuizQuestion>[];

    for (final q in questionsData) {
      final questionId = q['question_id'].toString();
      final correctPlantId = q['correct_plant_id'].toString();
      final datasetImage =
          q['plant_dataset_images'] ?? q['plant_dataset_image'];

      // Handle various response types for joined images
      String imageUrl =
          q['image_url']?.toString() ?? ''; // Fallback to direct field

      if (imageUrl.isEmpty) {
        if (datasetImage is Map) {
          imageUrl =
              datasetImage['image_url']?.toString() ??
              datasetImage['url']?.toString() ??
              datasetImage['image']?.toString() ??
              '';
        } else if (datasetImage is List && datasetImage.isNotEmpty) {
          final firstImage = datasetImage[0];
          if (firstImage is Map) {
            imageUrl =
                firstImage['image_url']?.toString() ??
                firstImage['url']?.toString() ??
                firstImage['image']?.toString() ??
                '';
          }
        }
      }

      // If still empty, we can't show an image, but we'll try to get it from correct plant's dataset if needed
      // but usually the join should suffice.

      // 3. Create options for this question
      var options = <PlantOption>[];

      // Ensure correct plant is included
      final correctFromPool = allPlantsPool
          .where((o) => o.plantId == correctPlantId)
          .toList();
      if (correctFromPool.isNotEmpty) {
        options.add(correctFromPool.first);
      } else {
        // Fallback: fetch correct plant if not in pool
        try {
          final correctPlantResult = await _supabase
              .from('plants')
              .select('plant_id, scientific_name, common_name')
              .eq('plant_id', correctPlantId)
              .single();
          options.add(PlantOption.fromJson(correctPlantResult));
        } catch (e) {
          // If we can'd find the correct plant, skip this question or add a placeholder
          continue;
        }
      }

      // Add wrong options from pool
      final wrongOptions =
          allPlantsPool.where((o) => o.plantId != correctPlantId).toList()
            ..shuffle();

      options.addAll(wrongOptions.take(4));
      options.shuffle();

      questions.add(
        QuizQuestion(
          questionId: questionId,
          quizId: q['quiz_id']?.toString(),
          imageUrl: imageUrl,
          correctPlantId: correctPlantId,
          options: options,
          hint: 'Identify this plant species native to Algeria.',
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

  /// Save the final quiz result/summary
  Future<void> saveQuizSummary({
    required String userId,
    required QuizResult result,
  }) async {
    await _supabase
        .from('quiz_attempts')
        .insert({
          'user_id': userId,
          'correct_answers': result.correctAnswers,
          'total_questions': result.totalQuestions,
          'xp_earned': result.totalXpEarned,
          'time_taken_seconds': result.timeTaken.inSeconds,
          'accuracy': result.accuracy,
        })
        .catchError((e) {
          // If table doesn't exist, we fallback to just xp_history which we already do
          // ignore: avoid_print
          print('quiz_attempts table might not exist: $e');
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
