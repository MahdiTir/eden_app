import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/scan/presentation/pages/scan_page.dart';
import '../../features/scan/presentation/pages/result_page.dart';
import '../../features/plant_profile/presentation/pages/plant_profile_screen.dart';
import 'dart:io';
import '../../core/services/plant_classifier_service.dart';

// Simple provider for the router
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
      GoRoute(
        path: '/plant-profile/:name',
        builder: (context, state) {
          final name = state.pathParameters['name']!;
          final imageUrl = state.uri.queryParameters['imageUrl'];
          return PlantProfileScreen(plantName: name, imageUrl: imageUrl);
        },
      ),
      GoRoute(
        path: '/scan',
        builder: (context, state) => const ScanPage(),
        routes: [
          GoRoute(
            path: 'result',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>;
              return ResultPage(
                image: extra['image'] as File,
                results: extra['results'] as List<PredictionResult>,
              );
            },
          ),
        ],
      ),
    ],
  );
});
