import 'package:flutter/material.dart';

class ResponsiveBreakpoints {
  final double width;

  ResponsiveBreakpoints(this.width);

  bool get sm => width < 601;
  bool get md => width >= 601 && width < 992;
  bool get lg => width >= 992;

  bool get isMobile => sm;
  bool get isTablet => md;
  bool get isDesktop => lg;
}

extension ResponsiveContext on BuildContext {
  ResponsiveBreakpoints get breakpoints {
    final screenWidth = MediaQuery.of(this).size.width;
    return ResponsiveBreakpoints(screenWidth);
  }

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}
