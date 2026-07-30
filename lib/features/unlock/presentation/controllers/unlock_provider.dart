import 'package:keymory_off/features/unlock/domain/usecases/unlock_with_biometrics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unlock_provider.g.dart';

/// Provides the [UnlockWithBiometrics] use case, so it can be overridden
/// with a mock in tests.
@riverpod
UnlockWithBiometrics unlockWithBiometrics(Ref ref) {
  return UnlockWithBiometrics();
}

/// Exposes the current unlock state as an [AsyncValue] and provides the
/// [unlock] action that the UI calls when the user taps the unlock button.
///
/// The wrapped `bool` is `false` while locked and `true` once unlocked, so
/// the UI can tell "not yet attempted" apart from "successfully unlocked"
/// — both of which would otherwise collapse into the same [AsyncData].
@riverpod
class Unlock extends _$Unlock {
  @override
  FutureOr<bool> build() => false;

  /// Triggers a biometric unlock attempt, updating [state] to
  /// [AsyncLoading] while it runs, then to [AsyncData] (true) or
  /// [AsyncError] carrying an [UnlockFailedException].
  Future<void> unlock() async {
    state = const AsyncLoading<bool>();
    final usecase = ref.read(unlockWithBiometricsProvider);
    state = await AsyncValue.guard<bool>(() async {
      await usecase();
      return true;
    });
  }
}
