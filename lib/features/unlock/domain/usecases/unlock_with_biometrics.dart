import 'package:keymory_off/features/unlock/domain/models/unlock_failure_reason.dart';
import 'package:local_auth/local_auth.dart';

/// Thrown when a biometric unlock attempt fails, carrying the specific
/// [reason] so the caller can decide how to respond.
class UnlockFailedException implements Exception {
  /// Creates an [UnlockFailedException] with the given [reason].
  const UnlockFailedException(this.reason);

  /// The specific reason this unlock attempt failed.
  final UnlockFailureReason reason;
}

/// Orchestrates the vault unlock flow: verifies that local authentication
/// is available on this device, then triggers the system's native
/// authentication prompt (biometrics, PIN, or password).
///
/// This use case does not touch the database or the encryption key directly
/// — it only answers "did the device confirm this is the owner?". Callers
/// are responsible for what happens after a successful unlock.
class UnlockWithBiometrics {
  /// Creates an [UnlockWithBiometrics] use case, optionally overriding the
  /// [LocalAuthentication] instance (mainly useful for testing).
  UnlockWithBiometrics({LocalAuthentication? localAuth})
    : _localAuth = localAuth ?? LocalAuthentication();

  final LocalAuthentication _localAuth;

  /// Attempts to unlock the vault using the device's local authentication.
  /// Throws [UnlockFailedException] on any failure path.
  Future<void> call() async {
    final isSupported = await _localAuth.isDeviceSupported();
    if (!isSupported) {
      throw const UnlockFailedException(UnlockFailureReason.noHardware);
    }

    try {
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Authenticate to unlock your vault',
      );

      if (!didAuthenticate) {
        throw const UnlockFailedException(UnlockFailureReason.cancelled);
      }
    } on LocalAuthException catch (e) {
      throw UnlockFailedException(_reasonFor(e.code));
    }
  }

  UnlockFailureReason _reasonFor(LocalAuthExceptionCode code) {
    return switch (code) {
      LocalAuthExceptionCode.noBiometricHardware =>
        UnlockFailureReason.noHardware,
      LocalAuthExceptionCode.temporaryLockout ||
      LocalAuthExceptionCode.biometricLockout =>
        UnlockFailureReason.tooManyAttempts,
      _ => UnlockFailureReason.unknown,
    };
  }
}
