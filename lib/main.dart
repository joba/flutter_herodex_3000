import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
      ],
      child: BlocProvider(
        create: (context) => AuthCubit(
          context.read<AuthRepository>(),
          analyticsManager: context.read<AnalyticsManager>(),
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Color(0xFF0a0c0a),
            colorScheme: const ColorScheme(
              brightness: Brightness.dark,
              primary: Color(0xFFFFB800),
              onPrimary: Color(0xFF0A0C0A),
              secondary: Color(0xFF2F3C7E),
              onSecondary: Colors.white,
              error: Color(0xFFB00020),
              onError: Colors.white,
              surface: Color(0xFF121212),
              onSurface: Colors.white,
            ),
            textTheme: TextTheme(
              headlineLarge: GoogleFonts.inter(
                color: const Color(0xFFFFB800),
                fontWeight: FontWeight.w300,
              ),
              bodyLarge: GoogleFonts.inter(color: const Color(0xFFCCCCCC)),
              bodyMedium: GoogleFonts.inter(color: const Color(0xFFCCCCCC)),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB800),
                foregroundColor: const Color(0xFF0A0C0A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                minimumSize: const Size.fromHeight(
                  48,
                ), // Full width + 48px height
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                textStyle: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            useMaterial3: true,
          ),
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
