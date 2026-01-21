import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/managers/crashlytics_manager.dart';
import 'package:flutter_herodex_3000/screens/search_screen.dart';
import 'package:flutter_herodex_3000/styles/themes.dart';
import 'package:flutter_herodex_3000/auth/cubit/auth_cubit.dart';
import 'package:flutter_herodex_3000/auth/cubit/auth_state.dart';
import 'package:flutter_herodex_3000/auth/repository/auth_repository.dart';
import 'package:flutter_herodex_3000/firebase_options.dart';
import 'package:flutter_herodex_3000/managers/analytics_manager.dart';
import 'package:flutter_herodex_3000/screens/home_screen.dart';
import 'package:flutter_herodex_3000/screens/login_screen.dart';
import 'package:flutter_herodex_3000/screens/onboarding_screen.dart';
import 'package:flutter_herodex_3000/widgets/navigation_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
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
        ],
      ),
      GoRoute(path: '/auth', builder: (context, state) => const AuthFlow()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) {
          final analyticsManager = context.read<AnalyticsManager>();
          final crashlyticsManager = context.read<CrashlyticsManager>();
          return OnboardingScreen(
            analyticsManager: analyticsManager,
            crashlyticsManager: crashlyticsManager,
          );
        },
      ),
      GoRoute(
        path: '/',
        builder: (context, state) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<AnalyticsManager>(
          create: (context) => AnalyticsManager(),
        ),
        RepositoryProvider<CrashlyticsManager>(
          create: (context) => CrashlyticsManager(),
        ),
      ],
      child: BlocProvider(
        create: (context) => AuthCubit(
          context.read<AuthRepository>(),
          analyticsManager: context.read<AnalyticsManager>(),
        ),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          routerConfig: _router,
        ),
      ),
    );
  }
}

class AuthFlow extends StatelessWidget {
  const AuthFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const HomeScreen();
        }
        if (state is AuthUnauthenticated || state is AuthError) {
          return const LoginScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
