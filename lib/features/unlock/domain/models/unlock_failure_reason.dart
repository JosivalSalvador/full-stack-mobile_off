/// Represents the specific reason a biometric unlock attempt failed.
///
/// Kept as a typed enum (instead of a raw error message) so that the UI
/// can decide what to show — and how to behave — based on the actual
/// cause, not on a hardcoded string coming from the domain layer.
enum UnlockFailureReason {
  /// The device has no biometric hardware and no PIN/password configured.
  noHardware,

  /// Too many failed attempts; the system temporarily locked authentication.
  tooManyAttempts,

  /// The user dismissed or cancelled the system authentication prompt.
  cancelled,

  /// Any other failure not covered by the reasons above.
  unknown,
}
