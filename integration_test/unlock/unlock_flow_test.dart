import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:keymory_off/features/unlock/domain/usecases/unlock_with_biometrics.dart';
import 'package:keymory_off/features/unlock/presentation/controllers/unlock_provider.dart';
import 'package:keymory_off/features/unlock/presentation/widgets/biometric_button.dart';
import 'package:keymory_off/main.dart';
import 'package:mockito/mockito.dart';

import '../../test/features/unlock/domain/usecases/unlock_with_biometrics_test.mocks.dart';

/// End-to-end coverage for the unlock flow: the app boots, shows the lock
/// screen, and reacts correctly to both a successful and a failed
/// biometric attempt.
///
/// Unlike `test/`, this runs the full widget tree exactly as `main()`
/// builds it, on a real device or emulator, rather than a unit or widget
/// test in isolation.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('unlock flow', () {
    testWidgets('shows the lock screen on launch', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: KeymoryApp()));
      await tester.pumpAndSettle();

      expect(find.text('Vault Locked'), findsOneWidget);
      expect(find.byType(BiometricButton), findsOneWidget);
    });

    testWidgets('unlocking succeeds and disables the button', (tester) async {
      final mockLocalAuth = MockLocalAuthentication();
      when(mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => true);
      when(
        mockLocalAuth.authenticate(
          localizedReason: anyNamed('localizedReason'),
        ),
      ).thenAnswer((_) async => true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            unlockWithBiometricsProvider.overrideWithValue(
              UnlockWithBiometrics(localAuth: mockLocalAuth),
            ),
          ],
          child: const KeymoryApp(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(BiometricButton));
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.descendant(
          of: find.byType(BiometricButton),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('a failed attempt shows the error message', (tester) async {
      final mockLocalAuth = MockLocalAuthentication();
      when(mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => false);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            unlockWithBiometricsProvider.overrideWithValue(
              UnlockWithBiometrics(localAuth: mockLocalAuth),
            ),
          ],
          child: const KeymoryApp(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(BiometricButton));
      await tester.pumpAndSettle();

      expect(
        find.text('No biometrics or device PIN are set up on this device.'),
        findsOneWidget,
      );
    });
  });
}
