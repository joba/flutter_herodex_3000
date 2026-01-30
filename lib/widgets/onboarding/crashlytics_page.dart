import 'package:flutter/material.dart';
import 'package:flutter_herodex_3000/config/texts.dart';
import 'package:flutter_herodex_3000/widgets/uppercase_elevated_button.dart';

class CrashlyticsPage extends StatelessWidget {
  final VoidCallback onNext;
  final bool crashlyticsEnabled;
  final ValueChanged<bool> onCrashlyticsChanged;

  const CrashlyticsPage({
    super.key,
    required this.onNext,
    required this.crashlyticsEnabled,
    required this.onCrashlyticsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            AppTexts.onboarding.crashLyticsTitle,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Text(
            AppTexts.onboarding.crashLyticsInfo,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppTexts.onboarding.enableCrashlytics,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Switch(
                value: crashlyticsEnabled,
                onChanged: (value) {
                  onCrashlyticsChanged(value);
                },
                activeThumbColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          const Spacer(),
          UpperCaseElevatedButton(
            onPressed: onNext,
            text: AppTexts.common.next,
          ),
        ],
      ),
    );
  }
}
