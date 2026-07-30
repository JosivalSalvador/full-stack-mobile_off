import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keymory_off/features/unlock/domain/usecases/unlock_with_biometrics.dart';
import 'package:keymory_off/features/unlock/presentation/controllers/unlock_provider.dart';
import 'package:keymory_off/features/unlock/presentation/screens/unlock_screen.dart';
import 'package:keymory_off/features/unlock/presentation/widgets/biometric_button.dart';
import 'package:keymory_off/l10n/app_localizations.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mockito/mockito.dart';

import '../../domain/usecases/unlock_with_biometrics_test.mocks.dart';

Widget _buildApp(ProviderScope providerScope) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: providerScope,
  );
}

void main() {
  testWidgets('displays the localized title and the unlock button', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildApp(const ProviderScope(child: UnlockScreen())),
    );

    expect(find.text('Vault Locked'), findsOneWidget);
    expect(find.byType(BiometricButton), findsOneWidget);
  });

  testWidgets('shows the failure reason after a failed unlock attempt', (
    tester,
  ) async {
    final mockLocalAuth = MockLocalAuthentication();
    when(mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => false);

    await tester.pumpWidget(
      _buildApp(
        ProviderScope(
          overrides: [
            unlockWithBiometricsProvider.overrideWithValue(
              UnlockWithBiometrics(localAuth: mockLocalAuth),
            ),
          ],
          child: const UnlockScreen(),
        ),
      ),
    );

    await tester.tap(find.byType(BiometricButton));
    await tester.pumpAndSettle();

    expect(
      find.text('No biometrics or device PIN are set up on this device.'),
      findsOneWidget,
    );
  });

  testWidgets('does not show a failure message before any attempt', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildApp(const ProviderScope(child: UnlockScreen())),
    );

    expect(
      find.text('No biometrics or device PIN are set up on this device.'),
      findsNothing,
    );
  });

  testWidgets('shows the generic error message for an unknown failure', (
    tester,
  ) async {
    final mockLocalAuth = MockLocalAuthentication();
    when(mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => true);
    when(
      mockLocalAuth.authenticate(
        localizedReason: anyNamed('localizedReason'),
      ),
    ).thenThrow(
      const LocalAuthException(code: LocalAuthExceptionCode.unknownError),
    );

    await tester.pumpWidget(
      _buildApp(
        ProviderScope(
          overrides: [
            unlockWithBiometricsProvider.overrideWithValue(
              UnlockWithBiometrics(localAuth: mockLocalAuth),
            ),
          ],
          child: const UnlockScreen(),
        ),
      ),
    );

    await tester.tap(find.byType(BiometricButton));
    await tester.pumpAndSettle();

    expect(find.text('Authentication failed. Try again.'), findsOneWidget);
  });
}
