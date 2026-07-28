// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unlock_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [UnlockWithBiometrics] use case, so it can be overridden
/// with a mock in tests.

@ProviderFor(unlockWithBiometrics)
final unlockWithBiometricsProvider = UnlockWithBiometricsProvider._();

/// Provides the [UnlockWithBiometrics] use case, so it can be overridden
/// with a mock in tests.

final class UnlockWithBiometricsProvider
    extends
        $FunctionalProvider<
          UnlockWithBiometrics,
          UnlockWithBiometrics,
          UnlockWithBiometrics
        >
    with $Provider<UnlockWithBiometrics> {
  /// Provides the [UnlockWithBiometrics] use case, so it can be overridden
  /// with a mock in tests.
  UnlockWithBiometricsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unlockWithBiometricsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unlockWithBiometricsHash();

  @$internal
  @override
  $ProviderElement<UnlockWithBiometrics> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UnlockWithBiometrics create(Ref ref) {
    return unlockWithBiometrics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UnlockWithBiometrics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UnlockWithBiometrics>(value),
    );
  }
}

String _$unlockWithBiometricsHash() =>
    r'8c38cfbb4c7629112e6f4de703f0602392679214';

/// Exposes the current [UnlockStatus] of the vault and provides the
/// [unlock] action that the UI calls when the user taps the unlock button.

@ProviderFor(Unlock)
final unlockProvider = UnlockProvider._();

/// Exposes the current [UnlockStatus] of the vault and provides the
/// [unlock] action that the UI calls when the user taps the unlock button.
final class UnlockProvider extends $NotifierProvider<Unlock, UnlockStatus> {
  /// Exposes the current [UnlockStatus] of the vault and provides the
  /// [unlock] action that the UI calls when the user taps the unlock button.
  UnlockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unlockProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unlockHash();

  @$internal
  @override
  Unlock create() => Unlock();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UnlockStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UnlockStatus>(value),
    );
  }
}

String _$unlockHash() => r'33a4e0df6b36283f938e2b336ff88f9f0ae5ccd4';

/// Exposes the current [UnlockStatus] of the vault and provides the
/// [unlock] action that the UI calls when the user taps the unlock button.

abstract class _$Unlock extends $Notifier<UnlockStatus> {
  UnlockStatus build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<UnlockStatus, UnlockStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UnlockStatus, UnlockStatus>,
              UnlockStatus,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
