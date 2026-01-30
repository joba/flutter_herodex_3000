import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsManager {
  final FirebaseAnalytics _analytics;
  bool _analyticsEnabled = false;
  bool _isInitialized = false;

  AnalyticsManager({FirebaseAnalytics? analytics})
    : _analytics = analytics ?? FirebaseAnalytics.instance;

  /// Initialize and load saved preference
  Future<void> initialize() async {
    if (_isInitialized) return;
    final prefs = await SharedPreferences.getInstance();
    _analyticsEnabled = prefs.getBool('analytics_enabled') ?? false;
    await _analytics.setAnalyticsCollectionEnabled(_analyticsEnabled);
    _isInitialized = true;
  }

  /// Check if analytics collection is enabled
  Future<bool> get isEnabled async {
    if (!_isInitialized) await initialize();
    return _analyticsEnabled;
  }

  /// Enable or disable analytics collection
  Future<void> setAnalyticsEnabled(bool enabled) async {
    _analyticsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('analytics_enabled', enabled);
    await _analytics.setAnalyticsCollectionEnabled(enabled);
  }

  /// Log an event only if analytics is enabled
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (!_analyticsEnabled) return;
    await _analytics.logEvent(name: name, parameters: parameters);
  }
}
