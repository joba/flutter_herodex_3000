import 'package:flutter/material.dart';

class AppSnackBar {
  BuildContext context;
  SnackBarBehavior? behavior;
  ThemeData theme;

  AppSnackBar.of(this.context, {this.behavior = SnackBarBehavior.fixed})
    : theme = Theme.of(context);

  void showError(String message) {
    final snackBar = SnackBar(
      content: Text(message, style: theme.textTheme.bodyMedium),
      backgroundColor: theme.colorScheme.error,
      behavior: behavior,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSuccess(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSecondary,
        ),
      ),
      backgroundColor: theme.colorScheme.secondary,
      behavior: behavior,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
