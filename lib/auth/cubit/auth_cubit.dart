import 'dart:async';
import 'package:flutter_herodex_3000/auth/cubit/auth_state.dart';
import 'package:flutter_herodex_3000/auth/repository/auth_repository.dart';
import 'package:flutter_herodex_3000/managers/analytics_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_herodex_3000/managers/crashlytics_manager.dart';
import 'package:flutter_herodex_3000/utils/logger.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final AnalyticsManager _analyticsManager;
  final CrashlyticsManager _crashlyticsManager;

  late final StreamSubscription<User?> _authStateSubscription;

  AuthCubit(
    this._authRepository, {
    AnalyticsManager? analyticsManager,
    CrashlyticsManager? crashlyticsManager,
  }) : _analyticsManager = analyticsManager ?? AnalyticsManager(),
       _crashlyticsManager = crashlyticsManager ?? CrashlyticsManager(),
       super(AuthInitial()) {
    _authStateSubscription = _authRepository.authStateChanges.listen((user) {
      AppLogger.log('Auth state changed: $user');
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        AppLogger.log('No authenticated user found');
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      await _authRepository.signIn(email: email, password: password);
      _analyticsManager.logEvent(
        name: 'login',
        parameters: {'method': 'email'},
      );
      _crashlyticsManager.setUserIdentifier(
        _authRepository.currentUser?.uid ?? 'unknown_user',
      );
    } catch (e, stackTrace) {
      _crashlyticsManager.recordError(
        e,
        stackTrace,
        reason: 'Failed to login user',
      );
      String errorMessage = 'An error occurred';
      String errorCode = 'unknown';

      if (e is FirebaseAuthException) {
        errorMessage = e.message.toString();
        errorCode = e.code.toString();
      } else if (e is Map<String, dynamic>) {
        errorMessage = e['message']?.toString() ?? 'An error occurred';
        errorCode = e['code']?.toString() ?? 'unknown';
      }

      emit(AuthError(errorMessage, errorCode));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      await _analyticsManager.logEvent(name: 'logout');
    } catch (e, stackTrace) {
      _crashlyticsManager.recordError(
        e,
        stackTrace,
        reason: 'Failed to logout user',
      );
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _authRepository.signUp(email: email, password: password);
      _analyticsManager.logEvent(
        name: 'sign_up',
        parameters: {'method': 'email'},
      );
    } catch (e, stackTrace) {
      _crashlyticsManager.recordError(
        e,
        stackTrace,
        reason: 'Failed to sign up user',
      );
      String errorMessage = 'An error occurred';
      String errorCode = 'unknown';

      if (e is FirebaseAuthException) {
        errorMessage = e.message.toString();
        errorCode = e.code.toString();
      } else if (e is Map<String, dynamic>) {
        errorMessage = e['message']?.toString() ?? 'An error occurred';
        errorCode = e['code']?.toString() ?? 'unknown';
      }

      emit(AuthError(errorMessage, errorCode));
      emit(AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }
}
