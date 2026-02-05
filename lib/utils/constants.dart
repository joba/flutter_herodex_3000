import 'package:flutter/foundation.dart';

class AppConstants {
  // UI
  static const double appMaxWidth = kIsWeb ? 1200 : 600;
  static const double appMaxHeight = kIsWeb ? 1000 : double.infinity;
  static const double cardHeight = 200;
  static const double borderRadius = 12;
  static const double cardPadding = 16;
  static const double cardIconSize = 28;
  static const double appPaddingBase = 16.0;

  // Timing
  static const searchDebounceDuration = Duration(milliseconds: 500);

  // Data
  static const int maxSearchHistory = 15;

  // Map
  static const double defaultMapZoom = 8.0;
  static const double defaultMapMinZoom = 3.0;
  static const double defaultMapMaxZoom = 18.0;
  static const double mapMarkerSize = 40.0;
  static const double mapHeight = 300.0;
}
