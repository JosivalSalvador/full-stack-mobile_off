import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keymory_off/features/unlock/domain/models/unlock_status.dart';
import 'package:keymory_off/features/unlock/presentation/controllers/unlock_provider.dart';
import 'package:keymory_off/features/unlock/presentation/widgets/biometric_button.dart';
import 'package:keymory_off/l10n/app_localizations.dart';

/// The screen shown when the vault is locked, prompting the user to
/// authenticate via [BiometricButton].
///
/// Displays the localized error message from a Failed status, if present.
class UnlockScreen extends ConsumerWidget {
  /// Creates an [UnlockScreen].
  const UnlockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(unlockProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

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
                if (status is Failed) ...[
                  const SizedBox(height: 16),
                  Text(
                    status.reason,
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
}
