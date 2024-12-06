import 'package:flutter/material.dart';

class ShowError {
  static void showError(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);

    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  static void showAuthError(BuildContext context, dynamic state) {
    final messenger = ScaffoldMessenger.of(context);

    messenger.showSnackBar(
      SnackBar(
        content: Text(state.toString()),
        backgroundColor: Colors.red,
      ),
    );
  }
}
