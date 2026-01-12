import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/home/presentation/pages/home_page.dart';

// Simple provider for the router
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation:
        '/onboarding', // TODO: Add logic to check if onboarding seen
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    ],
  );
});
