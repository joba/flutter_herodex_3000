import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashlyticsManager {
  static final CrashlyticsManager _instance = CrashlyticsManager._internal();
  factory CrashlyticsManager() => _instance;
  CrashlyticsManager._internal();

  bool _crashlyticsEnabled = false;

  /// Initialize crashlytics based on user consent
  Future<void> initialize({required bool userConsent}) async {
    _crashlyticsEnabled = userConsent;

    if (_crashlyticsEnabled) {
      // Enable crashlytics collection
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

      // Set up automatic crash reporting for Flutter errors
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      // Set up automatic crash reporting for async errors
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    } else {
      // Disable crashlytics collection
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    }
  }

  /// Record a non-fatal exception
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
  }) async {
    debugPrint(
      _crashlyticsEnabled
          ? 'Recording error to Crashlytics: $error'
          : 'Crashlytics is disabled; not recording error.',
    );
    if (!_crashlyticsEnabled) return;

    await FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: false,
    );
  }

  /// Log a message to crashlytics
  void log(String message) {
    if (!_crashlyticsEnabled) return;

    FirebaseCrashlytics.instance.log(message);
  }

  /// Set user identifier
  Future<void> setUserIdentifier(String userId) async {
    if (!_crashlyticsEnabled) return;

    await FirebaseCrashlytics.instance.setUserIdentifier(userId);
  }

  /// Set custom key-value pair
  Future<void> setCustomKey(String key, dynamic value) async {
    if (!_crashlyticsEnabled) return;

    await FirebaseCrashlytics.instance.setCustomKey(key, value);
  }

  /// Update user consent and reinitialize
  Future<void> updateConsent(bool userConsent) async {
    await initialize(userConsent: userConsent);
  }

  bool get isEnabled => _crashlyticsEnabled;
}
