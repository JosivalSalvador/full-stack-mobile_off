import 'package:flutter_test/flutter_test.dart';
import 'package:keymory_off/features/unlock/domain/models/unlock_failure_reason.dart';
import 'package:keymory_off/features/unlock/domain/usecases/unlock_with_biometrics.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'unlock_with_biometrics_test.mocks.dart';

@GenerateMocks([LocalAuthentication])
void main() {
  late MockLocalAuthentication mockLocalAuth;
  late UnlockWithBiometrics usecase;

  setUp(() {
    mockLocalAuth = MockLocalAuthentication();
    usecase = UnlockWithBiometrics(localAuth: mockLocalAuth);
  });

  test('completes normally when authentication succeeds', () async {
    when(mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => true);
    when(
      mockLocalAuth.authenticate(
        localizedReason: anyNamed('localizedReason'),
      ),
    ).thenAnswer((_) async => true);

    await expectLater(usecase(), completes);
  });

  test('throws noHardware when the device is not supported', () async {
    when(mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => false);

    await expectLater(
      usecase(),
      throwsA(
        isA<UnlockFailedException>().having(
          (e) => e.reason,
          'reason',
          UnlockFailureReason.noHardware,
        ),
      ),
    );
  });

  test('throws cancelled when authentication returns false', () async {
    when(mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => true);
    when(
      mockLocalAuth.authenticate(
        localizedReason: anyNamed('localizedReason'),
      ),
    ).thenAnswer((_) async => false);

    await expectLater(
      usecase(),
      throwsA(
        isA<UnlockFailedException>().having(
          (e) => e.reason,
          'reason',
          UnlockFailureReason.cancelled,
        ),
      ),
    );
  });

  test(
    'throws noHardware on LocalAuthException with noBiometricHardware code',
    () async {
      when(mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => true);
      when(
        mockLocalAuth.authenticate(
          localizedReason: anyNamed('localizedReason'),
        ),
      ).thenThrow(
        const LocalAuthException(
          code: LocalAuthExceptionCode.noBiometricHardware,
        ),
      );

      await expectLater(
        usecase(),
        throwsA(
          isA<UnlockFailedException>().having(
            (e) => e.reason,
            'reason',
            UnlockFailureReason.noHardware,
          ),
        ),
      );
    },
  );
}
