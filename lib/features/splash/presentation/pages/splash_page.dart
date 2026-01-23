import 'dart:ui' as ui;
import 'package:eden_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/providers/storage_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinController;

  // Colors from the design
  static const Color kPrimaryColor = Color(0xFF13ec6d);
  static const Color kBgLight = Color(0xFFf6f8f7);
  static const Color kBgDark = Color(0xFF102218);

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _checkOnboardingAndNavigate();
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  Future<void> _checkOnboardingAndNavigate() async {
    // Wait for the animation (2.5s) plus a small buffer
    await Future.delayed(const Duration(milliseconds: 3000));

    if (!mounted) return;

    // ignore: unused_local_variable
    final prefs = ref.read(sharedPreferencesProvider);
    final onboardingSeen = prefs.getBool(StorageKeys.onboardingSeen) ?? false;

    if (onboardingSeen) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }

  ui.ImageFilter _makeBlur(double sigma) {
    return ui.ImageFilter.blur(sigmaX: sigma, sigmaY: sigma);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? kBgDark : kBgLight;
    final textColor = isDark ? Colors.white : kBgDark;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Background Decor: Subtle nature pattern overlay
          Positioned.fill(
            child: Opacity(
              opacity: isDark ? 0.05 : 0.03,
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuBs2aY7WzYn5e1AISdIitkemX-o2LeJp8FMJYXuIr6DWnRT2GEIPi7iA9THu-Jm7b-XXdyMts-JlgoWREDqODifA973CKOiCaFrFx48ww6H6EN-F4ohRTECPGENXwhsnwN8KYN67w6nre-WetCQTcAhem3W5b20D5E0dp3bfTjy14LZi66FFfOy73sPXktwZ7MwMI_TwiKEWOwlhQtlke4kETf3vE8Zzf2utHXIoB_5mL-sJ_MzEy75REg0zooewkzRufwZA6xLQXU',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ),

          // Background Gradient Orb for vibrancy (Top Left)
          Positioned(
            top: -100,
            left: -100,
            child: ImageFiltered(
              imageFilter: _makeBlur(80),
              child: Container(
                width: MediaQuery.of(context).size.height * 0.5,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPrimaryColor.withValues(alpha: 0.2),
                ),
              ),
            ),
          ),

          // Background Gradient Orb (Bottom Right)
          Positioned(
            bottom: -80,
            right: -80,
            child: ImageFiltered(
              imageFilter: _makeBlur(60),
              child: Container(
                width: MediaQuery.of(context).size.height * 0.4,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPrimaryColor.withValues(alpha: 0.1),
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Logo & Title Section with FadeIn
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 10 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        // Logo Section
                        Container(
                          margin: const EdgeInsets.only(bottom: 32),
                          width: 180,
                          height: 180,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer glow ring using ImageFiltered for blur
                              Positioned.fill(
                                child: ImageFiltered(
                                  imageFilter: _makeBlur(12),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: [
                                          kPrimaryColor,
                                          kPrimaryColor.withValues(alpha: 0.5),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Logo Container
                              Container(
                                width: 180,
                                height: 180,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF1a3526)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    32,
                                  ), // 2rem
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xff14532d,
                                      ).withValues(alpha: 0.05),
                                      blurRadius: 24,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  'assets/images/logo_eden.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // App Name
                        Text(
                          l10n.appName,
                          style: GoogleFonts.lexend(
                            fontSize: 48, // 5xl roughly
                            fontWeight: FontWeight.w900,
                            color: textColor,
                            height: 1.1,
                            letterSpacing: -1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        // Tagline
                        Text(
                          l10n.appTagline,
                          style: GoogleFonts.lexend(
                            fontSize: 18, // lg
                            fontWeight: FontWeight.w400, // normal
                            color: textColor.withValues(alpha: 0.7),
                            letterSpacing: 0.5, // wide
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Bottom Section: Loading Indicator
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 48,
                      left: 32,
                      right: 32,
                    ),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(opacity: value, child: child);
                      },
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 2500),
                        curve: const Cubic(0.4, 0, 0.2, 1),
                        builder: (context, progress, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Status Text and Percentage
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      RotationTransition(
                                        turns: _spinController,
                                        child: const Icon(
                                          Icons.eco,
                                          color: kPrimaryColor,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        l10n.splashLoading,
                                        style: GoogleFonts.notoSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: textColor.withValues(
                                            alpha: 0.8,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${(progress * 100).toInt()}%",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Custom Progress Bar
                              Container(
                                height: 8,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Stack(
                                      children: [
                                        Container(
                                          width:
                                              constraints.maxWidth * progress,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: kPrimaryColor.withValues(
                                                  alpha: 0.5,
                                                ),
                                                blurRadius: 10,
                                                spreadRadius: 0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.splashFooter,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.notoSans(
                                  fontSize: 12,
                                  color: textColor.withValues(alpha: 0.3),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
