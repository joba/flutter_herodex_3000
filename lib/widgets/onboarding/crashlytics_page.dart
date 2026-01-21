import 'package:flutter/material.dart';
import 'package:flutter_herodex_3000/widgets/uppercase_elevated_button.dart';

class CrashlyticsPage extends StatelessWidget {
  final VoidCallback nextPage;
  final bool crashlyticsEnabled;
  final ValueChanged<bool> onCrashlyticsChanged;

  const CrashlyticsPage({
    super.key,
    required this.nextPage,
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
            'Crashlytics'.toUpperCase(),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'We use Crashlytics to understand how you use our app and make it better. Your data is anonymous and secure.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Enable Crashlytics',
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
          UpperCaseElevatedButton(onPressed: nextPage, text: 'Next'),
        ],
      ),
    );
  }
}
