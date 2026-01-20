import 'package:flutter/material.dart';

class UpperCaseElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final ButtonStyle? style;

  const UpperCaseElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: Text(text.toUpperCase()),
    );
  }
}
