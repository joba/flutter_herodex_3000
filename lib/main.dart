import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/managers/crashlytics_manager.dart';
import 'package:flutter_herodex_3000/styles/themes.dart';
import 'package:flutter_herodex_3000/auth/cubit/auth_cubit.dart';
import 'package:flutter_herodex_3000/auth/cubit/auth_state.dart';
import 'package:flutter_herodex_3000/auth/repository/auth_repository.dart';
import 'package:flutter_herodex_3000/firebase_options.dart';
import 'package:flutter_herodex_3000/managers/analytics_manager.dart';
import 'package:flutter_herodex_3000/screens/home_screen.dart';
import 'package:flutter_herodex_3000/screens/login_screen.dart';
import 'package:flutter_herodex_3000/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          routes: {'/auth': (context) => const AuthFlow()},
          home: const OnboardingCheck(),
        ),
      ),
    );
  }
}

class OnboardingCheck extends StatelessWidget {
  const OnboardingCheck({super.key});

  Future<bool> _checkOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_completed') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkOnboardingCompleted(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final onboardingCompleted = snapshot.data ?? false;

        if (!onboardingCompleted) {
          return OnboardingScreen(
            analyticsManager: context.read<AnalyticsManager>(),
            crashlyticsManager: context.read<CrashlyticsManager>(),
          );
        }

        return const AuthFlow();
      },
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
