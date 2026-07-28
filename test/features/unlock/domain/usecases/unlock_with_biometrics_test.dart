import 'package:flutter_test/flutter_test.dart';
import 'package:keymory_off/features/unlock/domain/models/unlock_status.dart';
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

  test('returns Unlocked when authentication succeeds', () async {
    when(mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => true);
    when(
      mockLocalAuth.authenticate(
        localizedReason: anyNamed('localizedReason'),
      ),
    ).thenAnswer((_) async => true);

    final result = await usecase();

    expect(result, isA<Unlocked>());
  });

  test('returns Failed when the device is not supported', () async {
    when(mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => false);

    final result = await usecase();

    expect(result, isA<Failed>());
    expect(
      (result as Failed).reason,
      'This device does not support local authentication.',
    );
  });

  test('returns Failed when authentication returns false', () async {
    when(mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => true);
    when(
      mockLocalAuth.authenticate(
        localizedReason: anyNamed('localizedReason'),
      ),
    ).thenAnswer((_) async => false);

    final result = await usecase();

    expect(result, isA<Failed>());
    expect((result as Failed).reason, 'Authentication was cancelled.');
  });

  test(
    'returns Failed with a specific message on LocalAuthException',
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

      final result = await usecase();

      expect(result, isA<Failed>());
      expect(
        (result as Failed).reason,
        'No biometrics or device PIN are set up on this device.',
      );
    },
  );
}
