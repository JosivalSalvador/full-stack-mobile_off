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

/// Exposes the current unlock state as an [AsyncValue] and provides the
/// [unlock] action that the UI calls when the user taps the unlock button.
///
/// The wrapped `bool` is `false` while locked and `true` once unlocked, so
/// the UI can tell "not yet attempted" apart from "successfully unlocked"
/// — both of which would otherwise collapse into the same [AsyncData].

@ProviderFor(Unlock)
final unlockProvider = UnlockProvider._();

/// Exposes the current unlock state as an [AsyncValue] and provides the
/// [unlock] action that the UI calls when the user taps the unlock button.
///
/// The wrapped `bool` is `false` while locked and `true` once unlocked, so
/// the UI can tell "not yet attempted" apart from "successfully unlocked"
/// — both of which would otherwise collapse into the same [AsyncData].
final class UnlockProvider extends $AsyncNotifierProvider<Unlock, bool> {
  /// Exposes the current unlock state as an [AsyncValue] and provides the
  /// [unlock] action that the UI calls when the user taps the unlock button.
  ///
  /// The wrapped `bool` is `false` while locked and `true` once unlocked, so
  /// the UI can tell "not yet attempted" apart from "successfully unlocked"
  /// — both of which would otherwise collapse into the same [AsyncData].
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
}

String _$unlockHash() => r'12401fdb17d7767f06f36b38ea317f940175ce3c';

/// Exposes the current unlock state as an [AsyncValue] and provides the
/// [unlock] action that the UI calls when the user taps the unlock button.
///
/// The wrapped `bool` is `false` while locked and `true` once unlocked, so
/// the UI can tell "not yet attempted" apart from "successfully unlocked"
/// — both of which would otherwise collapse into the same [AsyncData].

abstract class _$Unlock extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
