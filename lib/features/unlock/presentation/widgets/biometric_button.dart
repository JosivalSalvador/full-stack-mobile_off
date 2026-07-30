import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keymory_off/core/widgets/app_button.dart';
import 'package:keymory_off/features/unlock/presentation/controllers/unlock_provider.dart';
import 'package:keymory_off/l10n/app_localizations.dart';

/// The button used on the unlock screen to trigger a biometric unlock
/// attempt.
///
/// Reads the unlock provider to show a loading state while unlocking, and
/// disables itself once already unlocked.
class BiometricButton extends ConsumerWidget {
  /// Creates a [BiometricButton].
  const BiometricButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(unlockProvider);
    final l10n = AppLocalizations.of(context);

    final isUnlocked = state.value ?? false;

    return AppButton(
      label: l10n.unlockButtonLabel,
      isLoading: state.isLoading,
      onPressed: state.isLoading || isUnlocked
          ? null
          : () => ref.read(unlockProvider.notifier).unlock(),
    );
  }
}
