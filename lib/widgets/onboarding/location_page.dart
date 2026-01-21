import 'package:flutter/material.dart';
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
            'Location'.toUpperCase(),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'We use location data to enhance your experience. Your data is anonymous and secure.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Enable Location',
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
            text: 'Finish',
          ),
        ],
      ),
    );
  }
}
