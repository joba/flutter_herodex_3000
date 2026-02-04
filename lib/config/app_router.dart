import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/blocs/hero_detail/hero_detail_bloc.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_bloc.dart';
import 'package:flutter_herodex_3000/main.dart';
import 'package:flutter_herodex_3000/managers/analytics_manager.dart';
import 'package:flutter_herodex_3000/managers/api_manager.dart';
import 'package:flutter_herodex_3000/managers/crashlytics_manager.dart';
import 'package:flutter_herodex_3000/managers/location_manager.dart';
import 'package:flutter_herodex_3000/screens/home_screen.dart';
import 'package:flutter_herodex_3000/screens/onboarding_screen.dart';
import 'package:flutter_herodex_3000/screens/roster_screen.dart';
import 'package:flutter_herodex_3000/screens/search_screen.dart';
import 'package:flutter_herodex_3000/screens/settings_screen.dart';
import 'package:flutter_herodex_3000/screens/splash_screen.dart';
import 'package:flutter_herodex_3000/utils/logger.dart';
import 'package:flutter_herodex_3000/widgets/hero_details/hero_details_widget.dart';
import 'package:flutter_herodex_3000/widgets/navigation_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final onboardingCompleted =
          prefs.getBool('onboarding_completed') ?? false;

      // If on root, redirect based on onboarding status
      if (state.matchedLocation == '/') {
        return onboardingCompleted ? '/auth' : '/onboarding';
      }

      // If onboarding not completed and trying to access other routes, redirect to onboarding
      if (!onboardingCompleted && state.matchedLocation != '/onboarding') {
        return '/onboarding';
      }

      return null; // No redirect needed
    } catch (e) {
      AppLogger.log('Router redirect error: $e');
      // On error, default to onboarding
      return '/onboarding';
    }
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return RootNavigation(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
          name: 'home',
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
          name: 'search',
        ),
        GoRoute(
          path: '/roster',
          builder: (context, state) => const RosterScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/auth', builder: (context, state) => const AuthFlow()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) {
        final analyticsManager = context.read<AnalyticsManager>();
        final crashlyticsManager = context.read<CrashlyticsManager>();
        final locationManager = context.read<LocationManager>();
        return OnboardingScreen(
          analyticsManager: analyticsManager,
          crashlyticsManager: crashlyticsManager,
          locationManager: locationManager,
        );
      },
    ),
    GoRoute(
      path: '/',
      builder: (context, state) =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    ),
    GoRoute(
      path: '/details/:id',
      name: 'details',
      builder: (context, state) {
        final heroId = state.pathParameters['id']!;

        // Try to get RosterBloc if available from context
        RosterBloc? rosterBloc;
        try {
          rosterBloc = context.read<RosterBloc>();
        } catch (_) {
          // RosterBloc not available, continue without it
        }

        return BlocProvider(
          create: (context) => HeroDetailBloc(
            apiManager: context.read<ApiManager>(),
            rosterBloc: rosterBloc,
          ),
          child: HeroDetails(id: heroId),
        );
      },
    ),
  ],
);
