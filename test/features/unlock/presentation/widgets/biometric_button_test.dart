import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keymory_off/features/unlock/domain/models/unlock_status.dart';
import 'package:keymory_off/features/unlock/domain/usecases/unlock_with_biometrics.dart';
import 'package:keymory_off/features/unlock/presentation/controllers/unlock_provider.dart';
import 'package:keymory_off/features/unlock/presentation/widgets/biometric_button.dart';
import 'package:keymory_off/l10n/app_localizations.dart';
import 'package:mockito/mockito.dart';

import '../../domain/usecases/unlock_with_biometrics_test.mocks.dart';

void main() {
  Widget buildApp({required List<Override> overrides}) {
    return ProviderScope(
      overrides: overrides,
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: BiometricButton()),
      ),
    );
  }

  testWidgets('displays the localized unlock label', (tester) async {
    await tester.pumpWidget(buildApp(overrides: []));

    expect(find.text('Unlock with biometrics'), findsOneWidget);
  });

  testWidgets('shows a loading indicator while unlocking', (tester) async {
    final mockLocalAuth = MockLocalAuthentication();
    when(mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => true);
    when(
      mockLocalAuth.authenticate(
        localizedReason: anyNamed('localizedReason'),
      ),
    ).thenAnswer(
      (_) => Future.delayed(const Duration(milliseconds: 100), () => true),
    );

    await tester.pumpWidget(
      buildApp(
        overrides: [
          unlockWithBiometricsProvider.overrideWithValue(
            UnlockWithBiometrics(localAuth: mockLocalAuth),
          ),
        ],
      ),
    );

    await tester.tap(find.byType(BiometricButton));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
  });

  testWidgets('disables itself once unlocked', (tester) async {
    final mockLocalAuth = MockLocalAuthentication();
    when(mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => true);
    when(
      mockLocalAuth.authenticate(
        localizedReason: anyNamed('localizedReason'),
      ),
    ).thenAnswer((_) async => true);

    await tester.pumpWidget(
      buildApp(
        overrides: [
          unlockWithBiometricsProvider.overrideWithValue(
            UnlockWithBiometrics(localAuth: mockLocalAuth),
          ),
        ],
      ),
    );

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
}
