import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eden_app/l10n/app_localizations.dart';
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

  void _nextPage(BuildContext context, int totalPages) {
    if (_currentPage < totalPages - 1) {
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
    final l10n = AppLocalizations.of(context)!;

    final List<OnboardingContent> contents = [
      OnboardingContent(
        title: "${l10n.onboardingTitle1}\n${l10n.onboardingTitle1Highlight}",
        description: l10n.onboardingDesc1,
        image: "assets/images/onboarding_1.png",
      ),
      OnboardingContent(
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDesc2,
        image: "assets/images/onboarding_2.png",
      ),
      OnboardingContent(
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDesc3,
        image: "assets/images/onboarding_3.png",
      ),
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 0.0),
                child: TextButton(
                  onPressed: () {
                    ref
                        .read(sharedPreferencesProvider)
                        .setBool(StorageKeys.onboardingSeen, true);
                    context.go('/home');
                  },
                  child: Text(
                    l10n.skip,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
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
                itemCount: contents.length,
                itemBuilder: (context, index) {
                  return _OnboardingStep(content: contents[index]);
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
                      contents.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.secondary
                              : AppColors.secondary.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _nextPage(context, contents.length),
                      child: Text(
                        _currentPage == contents.length - 1
                            ? l10n.getStarted
                            : l10n.next,
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
    final parts = content.title.split('\n');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Maximize image space using Expanded while keeping the original proportions
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(content.image),
                fit: BoxFit.contain, // Best fit without cropping
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: parts[0] + (parts.length > 1 ? '\n' : ''),
                      style: AppTextStyles.h1.copyWith(
                        fontSize: 26,
                        height: 1.2,
                      ),
                    ),
                    if (parts.length > 1)
                      TextSpan(
                        text: parts[1],
                        style: AppTextStyles.h1.copyWith(
                          fontSize: 34,
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                content.description,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
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
