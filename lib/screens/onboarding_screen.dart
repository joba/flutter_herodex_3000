import 'package:flutter/material.dart';
import 'package:flutter_herodex_3000/widgets/uppercase_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_herodex_3000/managers/analytics_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

const String logo = 'assets/herodex_3000.svg';
final Widget logoWidget = SvgPicture.asset(
  logo,
  semanticsLabel: 'Herodex 3000 Logo',
);

class OnboardingScreen extends StatefulWidget {
  final AnalyticsManager analyticsManager;

  const OnboardingScreen({super.key, required this.analyticsManager});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding({required bool analyticsConsent}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    await widget.analyticsManager.setAnalyticsEnabled(analyticsConsent);

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/auth');
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
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [_buildWelcomePage(), _buildAnalyticsPage()],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPageIndicator(0),
                  const SizedBox(width: 8),
                  _buildPageIndicator(1),
                ],
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

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          logoWidget,
          const SizedBox(height: 32),
          Text(
            'HeroDex 3000'.toUpperCase(),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'Thank you for choosing our app. Let\'s get you started with a quick setup.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 48),
          UpperCaseElevatedButton(onPressed: _nextPage, text: 'Next'),
        ],
      ),
    );
  }

  Widget _buildAnalyticsPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 100,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 32),
          Text(
            'Help Us Improve',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'We use analytics to understand how you use our app and make it better. Your data is anonymous and secure.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () => _completeOnboarding(analyticsConsent: true),
            child: const Text('Accept'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => _completeOnboarding(analyticsConsent: false),
            child: const Text('Decline'),
          ),
        ],
      ),
    );
  }
}
