import 'package:flutter/material.dart';
import 'package:flutter_herodex_3000/config/texts.dart';
import 'package:flutter_herodex_3000/widgets/uppercase_elevated_button.dart';

class LocationPage extends StatelessWidget {
  final VoidCallback completeOnboarding;
  final bool locationEnabled;
  final ValueChanged<bool> onLocationChanged;
  const LocationPage({
    super.key,
    required this.completeOnboarding,
    required this.locationEnabled,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            AppTexts.onboarding.locationTitle,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Text(
            AppTexts.onboarding.locationInfo,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppTexts.onboarding.enableLocation,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Switch(
                value: locationEnabled,
                onChanged: (value) {
                  onLocationChanged(value);
                },
                activeThumbColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          const Spacer(),
          UpperCaseElevatedButton(
            onPressed: completeOnboarding,
            text: AppTexts.onboarding.finish,
          ),
        ],
      ),
    );
  }
}
