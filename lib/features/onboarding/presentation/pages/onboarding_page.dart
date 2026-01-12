import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/providers/storage_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = const [
    OnboardingContent(
      title: "Discover Algeria's Flora",
      description:
          "Instantly recognize local plants. Point your camera at any flower or tree to unlock the secrets of nature.",
      image: "assets/images/onboarding_1.png", // Placeholder
    ),
    OnboardingContent(
      title: "Know Your Plants Inside Out",
      description:
          "Access detailed botanical data on local Algerian flora and instantly detect potential diseases.",
      image: "assets/images/onboarding_2.png", // Placeholder
    ),
    OnboardingContent(
      title: "Play & Learn Anywhere",
      description:
          "Test your knowledge with fun quizzes and identify plants in the deepest Sahara without internet.",
      image: "assets/images/onboarding_3.png", // Placeholder
    ),
  ];

  void _nextPage() {
    if (_currentPage < _contents.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Save onboarding seen
      ref
          .read(sharedPreferencesProvider)
          .setBool(StorageKeys.onboardingSeen, true);
      // Go to Home
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  ref
                      .read(sharedPreferencesProvider)
                      .setBool(StorageKeys.onboardingSeen, true);
                  context.go('/home');
                },
                child: Text(
                  "Skip",
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _contents.length,
                itemBuilder: (context, index) {
                  return _OnboardingStep(content: _contents[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _contents.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.secondary
                              : AppColors.secondary.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(
                        _currentPage == _contents.length - 1
                            ? "Get Started"
                            : "Next",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingStep extends StatelessWidget {
  final OnboardingContent content;

  const _OnboardingStep({required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image placeholder container
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              margin: const EdgeInsets.only(bottom: 40),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                  image: AssetImage(content.image),
                  fit: BoxFit.contain,
                ),
              ),
              // child: const Center(child: Icon(Icons.image, size: 64, color: Colors.grey)),
            ),
          ),
          Text(
            content.title,
            style: AppTextStyles.h1.copyWith(
              fontSize: 28,
            ), // Slightly smaller for mobile
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            content.description,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingContent {
  final String title;
  final String description;
  final String image;

  const OnboardingContent({
    required this.title,
    required this.description,
    required this.image,
  });
}
