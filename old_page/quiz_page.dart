import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// Model for a quiz question
class QuizQuestion {
  final String id;
  final String question;
  final String? imagePath;
  final String? imageUrl;
  final String hint;
  final List<QuizOption> options;
  final int correctIndex;
  final int xpReward;
  final String? explanation;

  const QuizQuestion({
    required this.id,
    required this.question,
    this.imagePath,
    this.imageUrl,
    required this.hint,
    required this.options,
    required this.correctIndex,
    this.xpReward = 60,
    this.explanation,
  });
}

/// Model for a quiz answer option
class QuizOption {
  final String scientificName;
  final String commonName;

  const QuizOption({
    required this.scientificName,
    required this.commonName,
  });
}

/// Model for quiz result/stats
class QuizResult {
  final int totalQuestions;
  final int correctAnswers;
  final int totalXpEarned;
  final int streak;
  final Duration timeTaken;

  const QuizResult({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.totalXpEarned,
    required this.streak,
    required this.timeTaken,
  });

  double get accuracy => totalQuestions > 0 
      ? (correctAnswers / totalQuestions) * 100 
      : 0;
}

class QuizPage extends StatefulWidget {
  final List<QuizQuestion>? questions;

  const QuizPage({super.key, this.questions});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  late List<QuizQuestion> _questions;
  int _currentQuestionIndex = 0;
  int? _selectedOptionIndex;
  bool _hasAnswered = false;
  bool _isCorrect = false;
  
  // Stats
  int _score = 0;
  int _correctCount = 0;
  int _streak = 0;
  int _maxStreak = 0;
  DateTime? _startTime;
  
  // Animations
  late AnimationController _shakeController;
  late AnimationController _bounceController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _questions = widget.questions ?? _getSampleQuestions();
    _startTime = DateTime.now();
    
    // Shake animation for wrong answer
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);
    
    // Bounce animation for correct answer
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1, end: 1.1)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(_bounceController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  List<QuizQuestion> _getSampleQuestions() {
    return const [
      QuizQuestion(
        id: '1',
        question: 'Identify this species',
        imagePath: 'assets/images/plant_olive.png',
        hint: 'This tree is iconic to the Mediterranean region and produces valuable oil.',
        options: [
          QuizOption(scientificName: 'Cedrus atlantica', commonName: 'Atlas Cedar'),
          QuizOption(scientificName: 'Olea europaea', commonName: 'Olive Tree'),
          QuizOption(scientificName: 'Quercus suber', commonName: 'Cork Oak'),
          QuizOption(scientificName: 'Pinus halepensis', commonName: 'Aleppo Pine'),
        ],
        correctIndex: 1,
        xpReward: 60,
        explanation: 'The Olive Tree (Olea europaea) is native to the Mediterranean and is extensively cultivated in Algeria for olive oil production.',
      ),
      QuizQuestion(
        id: '2',
        question: 'What plant is this?',
        imagePath: 'assets/images/plant_dates.png',
        hint: 'Known as the "Queen of Dates", this palm produces a famous Algerian variety.',
        options: [
          QuizOption(scientificName: 'Phoenix dactylifera', commonName: 'Date Palm'),
          QuizOption(scientificName: 'Cocos nucifera', commonName: 'Coconut Palm'),
          QuizOption(scientificName: 'Washingtonia filifera', commonName: 'California Fan Palm'),
          QuizOption(scientificName: 'Chamaerops humilis', commonName: 'European Fan Palm'),
        ],
        correctIndex: 0,
        xpReward: 60,
        explanation: 'The Date Palm (Phoenix dactylifera) produces the famous Deglet Nour dates from Biskra, Algeria.',
      ),
      QuizQuestion(
        id: '3',
        question: 'Name this aromatic herb',
        imagePath: 'assets/images/plant_mint.png',
        hint: 'This refreshing herb is essential in Algerian tea culture.',
        options: [
          QuizOption(scientificName: 'Ocimum basilicum', commonName: 'Basil'),
          QuizOption(scientificName: 'Rosmarinus officinalis', commonName: 'Rosemary'),
          QuizOption(scientificName: 'Mentha spicata', commonName: 'Spearmint'),
          QuizOption(scientificName: 'Thymus vulgaris', commonName: 'Thyme'),
        ],
        correctIndex: 2,
        xpReward: 60,
        explanation: 'Spearmint (Mentha spicata) is the key ingredient in traditional Algerian mint tea.',
      ),
      QuizQuestion(
        id: '4',
        question: 'Identify this flowering shrub',
        imagePath: 'assets/images/plant_oleander.png',
        hint: 'Beautiful but toxic, this plant thrives in the Mediterranean climate.',
        options: [
          QuizOption(scientificName: 'Nerium oleander', commonName: 'Oleander'),
          QuizOption(scientificName: 'Hibiscus rosa-sinensis', commonName: 'Hibiscus'),
          QuizOption(scientificName: 'Bougainvillea glabra', commonName: 'Bougainvillea'),
          QuizOption(scientificName: 'Lantana camara', commonName: 'Lantana'),
        ],
        correctIndex: 0,
        xpReward: 60,
        explanation: 'Oleander (Nerium oleander) is common in Algeria but all parts are highly toxic.',
      ),
      QuizQuestion(
        id: '5',
        question: 'What desert plant is this?',
        imagePath: 'assets/images/plant_cactus.png',
        hint: 'This plant produces edible fruits and is used for traditional medicine.',
        options: [
          QuizOption(scientificName: 'Aloe vera', commonName: 'Aloe'),
          QuizOption(scientificName: 'Agave americana', commonName: 'Century Plant'),
          QuizOption(scientificName: 'Opuntia ficus-indica', commonName: 'Barbary Fig'),
          QuizOption(scientificName: 'Euphorbia resinifera', commonName: 'Resin Spurge'),
        ],
        correctIndex: 2,
        xpReward: 60,
        explanation: 'The Barbary Fig (Opuntia ficus-indica) is widely cultivated in Algeria for its fruit and medicinal oil.',
      ),
    ];
  }

  QuizQuestion get _currentQuestion => _questions[_currentQuestionIndex];
  double get _progress => (_currentQuestionIndex + 1) / _questions.length;
  bool get _isLastQuestion => _currentQuestionIndex >= _questions.length - 1;

  void _selectOption(int index) {
    if (_hasAnswered) return;
    
    setState(() {
      _selectedOptionIndex = index;
    });
  }

  void _submitAnswer() {
    if (_selectedOptionIndex == null || _hasAnswered) return;

    final isCorrect = _selectedOptionIndex == _currentQuestion.correctIndex;
    
    setState(() {
      _hasAnswered = true;
      _isCorrect = isCorrect;
      
      if (isCorrect) {
        _correctCount++;
        _streak++;
        if (_streak > _maxStreak) _maxStreak = _streak;
        
        // Calculate bonus XP for streak
        int xp = _currentQuestion.xpReward;
        if (_streak >= 3) xp += 20; // Streak bonus
        if (_streak >= 5) xp += 30; // Big streak bonus
        _score += xp;
        
        _bounceController.forward().then((_) => _bounceController.reverse());
      } else {
        _streak = 0;
        _shakeController.forward().then((_) => _shakeController.reset());
      }
    });

    // Show feedback
    _showAnswerFeedback(isCorrect);
  }

  void _showAnswerFeedback(bool isCorrect) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => _AnswerFeedbackSheet(
        isCorrect: isCorrect,
        explanation: _currentQuestion.explanation ?? '',
        xpEarned: isCorrect ? _currentQuestion.xpReward + (_streak >= 3 ? 20 : 0) + (_streak >= 5 ? 30 : 0) : 0,
        streak: _streak,
        onContinue: () {
          Navigator.pop(context);
          if (_isLastQuestion) {
            _showResults();
          } else {
            _nextQuestion();
          }
        },
      ),
    );
  }

  void _nextQuestion() {
    setState(() {
      _currentQuestionIndex++;
      _selectedOptionIndex = null;
      _hasAnswered = false;
      _isCorrect = false;
    });
  }

  void _showResults() {
    final result = QuizResult(
      totalQuestions: _questions.length,
      correctAnswers: _correctCount,
      totalXpEarned: _score,
      streak: _maxStreak,
      timeTaken: DateTime.now().difference(_startTime!),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => _QuizResultsPage(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(),
            
            // Progress Section
            _buildProgressSection(),
            
            // Question Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    
                    // Question Text
                    Text(
                      _currentQuestion.question,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMainLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Question Image
                    _buildQuestionImage(),
                    
                    const SizedBox(height: 12),
                    
                    // Hint Text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        _currentQuestion.hint,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSubLight,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Answer Options
                    ..._buildOptions(),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            
            // Bottom Submit Button
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _showExitConfirmation(),
            icon: const Icon(Icons.arrow_back_ios_new),
            color: AppColors.textMainLight,
          ),
          const Expanded(
            child: Text(
              'Quiz Challenge',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Streak indicator
          if (_streak > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_fire_department, size: 16, color: Colors.orange.shade700),
                  const SizedBox(width: 4),
                  Text(
                    '$_streak',
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

  Widget _buildProgressSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'QUESTION ${_currentQuestionIndex + 1}/${_questions.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
              AnimatedBuilder(
                animation: _bounceAnimation,
                builder: (context, child) => Transform.scale(
                  scale: _bounceAnimation.value,
                  child: child,
                ),
                child: Row(
                  children: [
                    Icon(Icons.stars, size: 16, color: Colors.amber.shade600),
                    const SizedBox(width: 4),
                    Text(
                      'Score: $_score',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSubLight,
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
              value: _progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionImage() {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(_shakeAnimation.value * (_hasAnswered && !_isCorrect ? 1 : 0), 0),
        child: child,
      ),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
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
              // Image
              if (_currentQuestion.imagePath != null)
                Image.asset(
                  _currentQuestion.imagePath!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.primary.withOpacity(0.1),
                    child: Icon(
                      Icons.eco,
                      size: 80,
                      color: AppColors.primary.withOpacity(0.5),
                    ),
                  ),
                )
              else if (_currentQuestion.imageUrl != null)
                Image.network(
                  _currentQuestion.imageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                        color: AppColors.primary,
                      ),
                    );
                  },
                ),
              
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
              
              // Zoom button
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.zoom_in,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOptions() {
    return List.generate(_currentQuestion.options.length, (index) {
      final option = _currentQuestion.options[index];
      final isSelected = _selectedOptionIndex == index;
      final isCorrectOption = index == _currentQuestion.correctIndex;
      
      Color borderColor = Colors.grey.shade200;
      Color backgroundColor = Colors.white;
      Color radioColor = Colors.grey.shade300;
      
      if (_hasAnswered) {
        if (isCorrectOption) {
          borderColor = AppColors.primary;
          backgroundColor = AppColors.primary.withOpacity(0.1);
          radioColor = AppColors.primary;
        } else if (isSelected && !isCorrectOption) {
          borderColor = Colors.red.shade400;
          backgroundColor = Colors.red.shade50;
          radioColor = Colors.red.shade400;
        }
      } else if (isSelected) {
        borderColor = AppColors.primary;
        backgroundColor = AppColors.primary.withOpacity(0.05);
        radioColor = AppColors.primary;
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
                  color: Colors.black.withOpacity(0.03),
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
                    color: isSelected || (_hasAnswered && isCorrectOption)
                        ? radioColor
                        : Colors.transparent,
                  ),
                  child: isSelected || (_hasAnswered && isCorrectOption)
                      ? Icon(
                          _hasAnswered
                              ? (isCorrectOption ? Icons.check : Icons.close)
                              : Icons.circle,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
                
                const SizedBox(width: 16),
                
                // Option text
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
                          color: AppColors.textMainLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        option.commonName,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSubLight,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Correct/wrong indicator
                if (_hasAnswered && (isSelected || isCorrectOption))
                  Icon(
                    isCorrectOption ? Icons.check_circle : Icons.cancel,
                    color: isCorrectOption ? AppColors.primary : Colors.red.shade400,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSubmitButton() {
    final canSubmit = _selectedOptionIndex != null && !_hasAnswered;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: canSubmit ? _submitAnswer : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: canSubmit ? AppColors.primary : Colors.grey.shade300,
              foregroundColor: canSubmit ? AppColors.textMainLight : Colors.grey.shade500,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: canSubmit ? 4 : 0,
              shadowColor: AppColors.primary.withOpacity(0.3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _hasAnswered
                      ? (_isLastQuestion ? 'See Results' : 'Next Question')
                      : 'Submit Answer',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
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
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Continue',
              style: TextStyle(color: AppColors.textSubLight),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
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
}

/// Answer Feedback Bottom Sheet
class _AnswerFeedbackSheet extends StatelessWidget {
  final bool isCorrect;
  final String explanation;
  final int xpEarned;
  final int streak;
  final VoidCallback onContinue;

  const _AnswerFeedbackSheet({
    required this.isCorrect,
    required this.explanation,
    required this.xpEarned,
    required this.streak,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isCorrect ? AppColors.primary.withOpacity(0.95) : Colors.red.shade400.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              size: 48,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Title
          Text(
            isCorrect ? 'Correct! 🎉' : 'Not quite right',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // XP earned (if correct)
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_fire_department, color: Colors.white, size: 14),
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
          
          // Explanation
          if (explanation.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                explanation,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.95),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          
          const SizedBox(height: 24),
          
          // Continue button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: isCorrect ? AppColors.primaryDark : Colors.red.shade700,
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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

/// Quiz Results Page
class _QuizResultsPage extends StatelessWidget {
  final QuizResult result;

  const _QuizResultsPage({required this.result});

  @override
  Widget build(BuildContext context) {
    final isPerfect = result.correctAnswers == result.totalQuestions;
    final isGood = result.accuracy >= 70;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
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
                          ? AppColors.primary.withOpacity(0.1)
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
                          ? AppColors.primary
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
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'You completed the quiz!',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSubLight,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Stats Grid
              Row(
                children: [
                  _buildStatCard(
                    icon: Icons.check_circle,
                    iconColor: AppColors.primary,
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
                    value: '${result.streak}',
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
                    Icon(Icons.timer_outlined, color: AppColors.textSubLight),
                    const SizedBox(width: 8),
                    Text(
                      'Time: ${_formatDuration(result.timeTaken)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSubLight,
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuizPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textMainLight,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: AppColors.primary.withOpacity(0.3),
                  ),
                  child: const Row(
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
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textMainLight,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: const Row(
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
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
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

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }
}
