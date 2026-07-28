/// Represents every possible state of the vault unlock flow.
///
/// Modeled as a sealed class (rather than a plain enum) so that each state
/// can carry only the data that is relevant to it — for example, Failed
/// carries a human-readable reason, while Locked carries nothing at all.
sealed class UnlockStatus {
  const UnlockStatus();
}

/// The vault is locked; no unlock attempt is in progress.
class Locked extends UnlockStatus {
  /// Creates a [Locked] status.
  const Locked();
}

/// A biometric authentication attempt is currently in progress.
class Unlocking extends UnlockStatus {
  /// Creates an [Unlocking] status.
  const Unlocking();
}

/// The vault was successfully unlocked.
class Unlocked extends UnlockStatus {
  /// Creates an [Unlocked] status.
  const Unlocked();
}

/// The unlock attempt failed, with [reason] describing what went wrong.
class Failed extends UnlockStatus {
  /// Creates a [Failed] status with the given [reason].
  const Failed(this.reason);

  /// A human-readable description of why the unlock attempt failed.
  final String reason;
}
