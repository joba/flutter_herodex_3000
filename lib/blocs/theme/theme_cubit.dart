import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/managers/analytics_manager.dart';
import 'package:flutter_herodex_3000/managers/crashlytics_manager.dart';
import 'package:flutter_herodex_3000/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final CrashlyticsManager _crashlyticsManager;
  final AnalyticsManager _analyticsManager;

  static const String _themeModeKey = 'theme_mode';

  ThemeCubit({
    CrashlyticsManager? crashlyticsManager,
    AnalyticsManager? analyticsManager,
  }) : _crashlyticsManager = crashlyticsManager ?? CrashlyticsManager(),
       _analyticsManager = analyticsManager ?? AnalyticsManager(),
       super(ThemeMode.dark) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeString = prefs.getString(_themeModeKey) ?? 'dark';
      emit(_getThemeModeFromString(themeModeString));
      _analyticsManager.logEvent(
        name: 'theme_mode_loaded',
        parameters: {'mode': themeModeString},
      );
    } catch (e, stackTrace) {
      // If loading fails, just keep the default dark mode
      AppLogger.log('Failed to load theme mode: $e');
      _crashlyticsManager.recordError(
        e,
        stackTrace,
        reason: 'Failed to load theme mode',
      );
      emit(ThemeMode.dark);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, _getStringFromThemeMode(mode));
      emit(mode);
    } catch (e, stackTrace) {
      AppLogger.log('Failed to save theme mode: $e');
      _crashlyticsManager.recordError(
        e,
        stackTrace,
        reason: 'Failed to save theme mode',
      );
      // Still emit the mode so UI updates even if save fails
      emit(mode);
    }
  }

  ThemeMode _getThemeModeFromString(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.dark;
    }
  }

  String _getStringFromThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
