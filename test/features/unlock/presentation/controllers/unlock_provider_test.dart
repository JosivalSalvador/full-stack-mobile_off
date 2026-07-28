import 'package:flutter_test/flutter_test.dart';
import 'package:keymory_off/features/unlock/domain/models/unlock_status.dart';
import 'package:keymory_off/features/unlock/domain/usecases/unlock_with_biometrics.dart';
import 'package:keymory_off/features/unlock/presentation/controllers/unlock_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

import '../../domain/usecases/unlock_with_biometrics_test.mocks.dart';

void main() {
  test('initial state is Locked', () {
    final container = ProviderContainer.test();

    final status = container.read(unlockProvider);

    expect(status, isA<Locked>());
  });

  test('unlock() transitions through Unlocking before settling', () async {
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

    final states = <UnlockStatus>[];
    container.listen(
      unlockProvider,
      (previous, next) => states.add(next),
      fireImmediately: true,
    );

    await container.read(unlockProvider.notifier).unlock();

    expect(states.first, isA<Locked>());
    expect(states[1], isA<Unlocking>());
    expect(states.last, isA<Unlocked>());
  });
}
