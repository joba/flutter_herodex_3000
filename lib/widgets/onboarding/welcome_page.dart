import 'package:flutter/material.dart';
import 'package:flutter_herodex_3000/widgets/uppercase_elevated_button.dart';

class WelcomePage extends StatelessWidget {
  final VoidCallback onNext;
  const WelcomePage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
          const Spacer(),
          UpperCaseElevatedButton(onPressed: onNext, text: 'Next'),
        ],
      ),
    );
  }
}
