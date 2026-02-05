import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_herodex_3000/managers/crashlytics_manager.dart';
import 'package:flutter_herodex_3000/managers/location_manager.dart';
import 'package:flutter_herodex_3000/utils/constants.dart';
import 'package:flutter_herodex_3000/utils/snackbar.dart';
import 'package:flutter_herodex_3000/widgets/herodex_logo.dart';
import 'package:flutter_herodex_3000/widgets/onboarding/analytics_page.dart';
import 'package:flutter_herodex_3000/widgets/onboarding/crashlytics_page.dart';
import 'package:flutter_herodex_3000/widgets/onboarding/location_page.dart';
import 'package:flutter_herodex_3000/widgets/onboarding/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_herodex_3000/managers/analytics_manager.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  final AnalyticsManager analyticsManager;
  final CrashlyticsManager crashlyticsManager;
  final LocationManager locationManager;

  const OnboardingScreen({
    super.key,
    required this.analyticsManager,
    required this.crashlyticsManager,
    required this.locationManager,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _analyticsEnabled = false;
  bool _crashlyticsEnabled = false;
  bool _locationEnabled = false;

  static const int _totalPages = kIsWeb ? 3 : 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);
      await widget.analyticsManager.setAnalyticsEnabled(_analyticsEnabled);

      // Crashlytics is not supported on web
      if (!kIsWeb) {
        await widget.crashlyticsManager.updateConsent(_crashlyticsEnabled);
      }

      // Set location preference
      await widget.locationManager.setLocationEnabled(_locationEnabled);

      widget.analyticsManager.logEvent(
        name: 'onboarding_completed',
        parameters: {
          'analytics_enabled': _analyticsEnabled.toString(),
          'crashlytics_enabled': _crashlyticsEnabled.toString(),
          'location_enabled': _locationEnabled.toString(),
        },
      );

      if (mounted) {
        context.go('/auth');
      }
    } catch (e, stackTrace) {
      widget.crashlyticsManager.recordError(
        e,
        stackTrace,
        reason: 'Failed to complete onboarding',
      );
      if (mounted) {
        AppSnackBar.of(context).showError('Failed to complete onboarding: $e');
      }
    }
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.appPaddingBase * 1.5),
              child: const HerodexLogo(),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  WelcomePage(onNext: _nextPage),
                  AnalyticsPage(
                    onNext: _nextPage,
                    analyticsEnabled: _analyticsEnabled,
                    onAnalyticsChanged: (value) {
                      setState(() {
                        _analyticsEnabled = value;
                      });
                    },
                  ),
                  if (!kIsWeb)
                    CrashlyticsPage(
                      onNext: _nextPage,
                      crashlyticsEnabled: _crashlyticsEnabled,
                      onCrashlyticsChanged: (value) {
                        setState(() {
                          _crashlyticsEnabled = value;
                        });
                      },
                    ),
                  LocationPage(
                    onNext: _completeOnboarding,
                    locationEnabled: _locationEnabled,
                    onLocationChanged: (value) {
                      setState(() {
                        _locationEnabled = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.appPaddingBase),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _totalPages,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.appPaddingBase / 4,
                    ),
                    child: _buildPageIndicator(index),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? Theme.of(context).colorScheme.primary
            : Colors.grey.shade300,
      ),
    );
  }
}
