import 'package:flutter/material.dart';
import 'package:flutter_herodex_3000/config/app_texts.dart';
import 'package:flutter_herodex_3000/widgets/uppercase_elevated_button.dart';

class AnalyticsPage extends StatelessWidget {
  final VoidCallback onNext;
  final bool analyticsEnabled;
  final ValueChanged<bool> onAnalyticsChanged;

  const AnalyticsPage({
    super.key,
    required this.onNext,
    required this.analyticsEnabled,
    required this.onAnalyticsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            AppTexts.onboarding.analyticsTitle,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Text(
            AppTexts.onboarding.analyticsInfo,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppTexts.onboarding.enableAnalytics,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Switch(
                value: analyticsEnabled,
                onChanged: onAnalyticsChanged,
                activeThumbColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          const Spacer(),
          UpperCaseElevatedButton(
            onPressed: onNext,
            child: Text(AppTexts.common.next),
          ),
        ],
      ),
    );
  }
}
