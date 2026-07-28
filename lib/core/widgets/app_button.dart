import 'package:flutter/material.dart';

/// The app's default button, used as the base for any specific button
/// across features. Wraps [ElevatedButton] with the app's standard style
/// and a built-in loading state.
class AppButton extends StatelessWidget {
  /// Creates an [AppButton] with the given [label] and [onPressed] callback.
  const AppButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  /// The text displayed on the button.
  final String label;

  /// Called when the button is tapped. Ignored while [isLoading] is true.
  final VoidCallback? onPressed;

  /// Whether to show a loading indicator instead of [label], and disable
  /// the button while doing so.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label),
    );
  }
}
