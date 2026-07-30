import 'package:flutter_test/flutter_test.dart';
import 'package:keymory_off/features/unlock/domain/models/unlock_failure_reason.dart';
import 'package:keymory_off/features/unlock/domain/usecases/unlock_with_biometrics.dart';
import 'package:keymory_off/features/unlock/presentation/controllers/unlock_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

import '../../domain/usecases/unlock_with_biometrics_test.mocks.dart';

void main() {
  test('initial state is unlocked = false', () {
    final container = ProviderContainer.test();

    final state = container.read(unlockProvider);

    expect(state, isA<AsyncData<bool>>());
    expect(state.value, isFalse);
  });

  test(
    'unlock() transitions through loading before settling on true',
    () async {
      final mockLocalAuth = MockLocalAuthentication();
      when(mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => true);
      when(
        mockLocalAuth.authenticate(
          localizedReason: anyNamed('localizedReason'),
        ),
      ).thenAnswer((_) async => true);

      final container = ProviderContainer.test(
        overrides: [
          unlockWithBiometricsProvider.overrideWithValue(
            UnlockWithBiometrics(localAuth: mockLocalAuth),
          ),
        ],
      );

      final states = <AsyncValue<bool>>[];
      container.listen(
        unlockProvider,
        (previous, next) => states.add(next),
        fireImmediately: true,
      );

      await container.read(unlockProvider.notifier).unlock();

      expect(states[1], isA<AsyncLoading<bool>>());
      expect(states.last.value, isTrue);
      expect(states.last.isLoading, isFalse);
    },
  );

  test(
    'unlock() settles on AsyncError with UnlockFailedException on failure',
    () async {
      final mockLocalAuth = MockLocalAuthentication();
      when(mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => false);

      final container = ProviderContainer.test(
        overrides: [
          unlockWithBiometricsProvider.overrideWithValue(
            UnlockWithBiometrics(localAuth: mockLocalAuth),
          ),
        ],
      );

      await container.read(unlockProvider.notifier).unlock();

      final state = container.read(unlockProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<UnlockFailedException>());
      expect(
        (state.error! as UnlockFailedException).reason,
        UnlockFailureReason.noHardware,
      );
    },
  );
}
