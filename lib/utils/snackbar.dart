import 'package:flutter/material.dart';

class AppSnackBar {
  BuildContext context;
  SnackBarBehavior? behavior;

  AppSnackBar.of(this.context, {this.behavior = SnackBarBehavior.fixed});

  void showError(String message) {
    final snackBar = SnackBar(
      content: Text(message, style: Theme.of(context).textTheme.bodyMedium),
      backgroundColor: Theme.of(context).colorScheme.error,
      behavior: behavior,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSuccess(String message) {
    final snackBar = SnackBar(
      content: Text(message, style: Theme.of(context).textTheme.bodyMedium),
      backgroundColor: Theme.of(context).colorScheme.surface,
      behavior: behavior,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
