import 'package:keymory_off/features/unlock/domain/models/unlock_status.dart';
import 'package:local_auth/local_auth.dart';

/// Orchestrates the vault unlock flow: verifies that local authentication
/// is available on this device, then triggers the system's native
/// authentication prompt (biometrics, PIN, or password).
///
/// This use case does not touch the database or the encryption key directly
/// — it only answers "did the device confirm this is the owner?". Callers
/// are responsible for what happens after a successful [Unlocked] result.
class UnlockWithBiometrics {
  /// Creates an [UnlockWithBiometrics] use case, optionally overriding the
  /// [LocalAuthentication] instance (mainly useful for testing).
  UnlockWithBiometrics({LocalAuthentication? localAuth})
    : _localAuth = localAuth ?? LocalAuthentication();

  final LocalAuthentication _localAuth;

  /// Attempts to unlock the vault using the device's local authentication.
  /// Never throws — every failure path is represented as a [Failed] status.
  Future<UnlockStatus> call() async {
    final isSupported = await _localAuth.isDeviceSupported();
    if (!isSupported) {
      return const Failed(
        'This device does not support local authentication.',
      );
    }

    try {
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Authenticate to unlock your vault',
      );

      return didAuthenticate
          ? const Unlocked()
          : const Failed('Authentication was cancelled.');
    } on LocalAuthException catch (e) {
      return Failed(_messageFor(e.code));
    }
  }

  String _messageFor(LocalAuthExceptionCode code) {
    return switch (code) {
      LocalAuthExceptionCode.noBiometricHardware =>
        'No biometrics or device PIN are set up on this device.',
      LocalAuthExceptionCode.temporaryLockout ||
      LocalAuthExceptionCode.biometricLockout =>
        'Too many attempts. Try again later.',
      _ => 'Authentication failed. Try again.',
    };
  }
}
