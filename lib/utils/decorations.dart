import 'package:flutter/material.dart';

BoxDecoration homeCardDecoration(BuildContext context, {Color? color}) {
  color ??= Theme.of(context).colorScheme.primary;

  return BoxDecoration(
    border: Border.all(color: color, width: 1),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(color: color.withAlpha(128), spreadRadius: 4, blurRadius: 10),
      BoxShadow(color: Colors.black, spreadRadius: 0, blurRadius: 0),
    ],
  );
}
