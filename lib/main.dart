import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_bloc.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_event.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_state.dart';
import 'package:flutter_herodex_3000/blocs/theme/theme_cubit.dart';
import 'package:flutter_herodex_3000/config/app_router.dart';
import 'package:flutter_herodex_3000/managers/api_manager.dart';
import 'package:flutter_herodex_3000/managers/crashlytics_manager.dart';
import 'package:flutter_herodex_3000/screens/home_screen.dart';
import 'package:flutter_herodex_3000/screens/splash_screen.dart';
import 'package:flutter_herodex_3000/styles/themes.dart';
import 'package:flutter_herodex_3000/auth/cubit/auth_cubit.dart';
import 'package:flutter_herodex_3000/auth/cubit/auth_state.dart';
import 'package:flutter_herodex_3000/auth/repository/auth_repository.dart';
import 'package:flutter_herodex_3000/firebase_options.dart';
import 'package:flutter_herodex_3000/managers/analytics_manager.dart';
import 'package:flutter_herodex_3000/screens/login_screen.dart';
import 'package:flutter_herodex_3000/utils/constants.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
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
        RepositoryProvider<ApiManager>(create: (context) => ApiManager()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(
              context.read<AuthRepository>(),
              analyticsManager: context.read<AnalyticsManager>(),
            ),
          ),
          BlocProvider<RosterBloc>(
            create: (context) => RosterBloc(
              apiManager: context.read<ApiManager>(),
              analyticsManager: context.read<AnalyticsManager>(),
              crashlyticsManager: context.read<CrashlyticsManager>(),
            ),
          ),
          BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeMode,
              routerConfig: appRouter,
              builder: (context, child) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppConstants.appMaxWidth,
                    ),
                    child: child ?? const SizedBox(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class AuthFlow extends StatelessWidget {
  const AuthFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              // Trigger roster loading when authenticated
              context.read<RosterBloc>().add(GetRoster());
            }
          },
        ),
        BlocListener<RosterBloc, RosterState>(
          listener: (context, state) {
            final authState = context.read<AuthCubit>().state;
            if (authState is AuthAuthenticated) {
              if (state is RosterLoaded) {
                context.go('/home');
              }
            }
          },
        ),
      ],
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthUnauthenticated || state is AuthError) {
            return const LoginScreen();
          }
          // Show splash while loading roster after authentication
          return BlocBuilder<RosterBloc, RosterState>(
            builder: (context, rosterState) {
              if (rosterState is RosterLoading ||
                  rosterState is RosterInitial) {
                return const SplashScreen();
              }
              return const HomeScreen();
            },
          );
        },
      ),
    );
  }
}
