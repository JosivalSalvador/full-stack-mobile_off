import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keymory_off/features/unlock/domain/models/unlock_failure_reason.dart';
import 'package:keymory_off/features/unlock/domain/usecases/unlock_with_biometrics.dart';
import 'package:keymory_off/features/unlock/presentation/controllers/unlock_provider.dart';
import 'package:keymory_off/features/unlock/presentation/widgets/biometric_button.dart';
import 'package:keymory_off/l10n/app_localizations.dart';

/// The screen shown when the vault is locked, prompting the user to
/// authenticate via [BiometricButton].
///
/// Displays a localized error message when the unlock state holds an
/// [UnlockFailedException].
class UnlockScreen extends ConsumerWidget {
  /// Creates an [UnlockScreen].
  const UnlockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(unlockProvider);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final errorMessage = switch (state) {
      AsyncError(:final error) when error is UnlockFailedException =>
        _messageFor(error.reason, l10n),
      _ => null,
    };

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.unlockScreenTitle,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const BiometricButton(),
                if (errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    errorMessage,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _messageFor(UnlockFailureReason reason, AppLocalizations l10n) {
    return switch (reason) {
      UnlockFailureReason.noHardware => l10n.unlockErrorNoHardware,
      UnlockFailureReason.tooManyAttempts => l10n.unlockErrorTooManyAttempts,
      UnlockFailureReason.cancelled => l10n.unlockErrorCancelled,
      UnlockFailureReason.unknown => l10n.unlockErrorUnknown,
    };
  }
}
