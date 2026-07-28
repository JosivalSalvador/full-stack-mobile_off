import 'package:keymory_off/features/unlock/domain/models/unlock_status.dart';
import 'package:keymory_off/features/unlock/domain/usecases/unlock_with_biometrics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unlock_provider.g.dart';

/// Provides the [UnlockWithBiometrics] use case, so it can be overridden
/// with a mock in tests.
@riverpod
UnlockWithBiometrics unlockWithBiometrics(Ref ref) {
  return UnlockWithBiometrics();
}

/// Exposes the current [UnlockStatus] of the vault and provides the
/// [unlock] action that the UI calls when the user taps the unlock button.
@riverpod
class Unlock extends _$Unlock {
  @override
  UnlockStatus build() => const Locked();

  /// Triggers a biometric unlock attempt, updating [state] as it
  /// progresses from [Unlocking] to either [Unlocked] or [Failed].
  Future<void> unlock() async {
    state = const Unlocking();
    final usecase = ref.read(unlockWithBiometricsProvider);
    state = await usecase();
  }
}
