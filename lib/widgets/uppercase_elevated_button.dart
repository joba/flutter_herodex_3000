import 'package:flutter/material.dart';

class UpperCaseElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final Widget child;

  const UpperCaseElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: child is Text ? Text((child as Text).data!.toUpperCase()) : child,
    );
  }
}
