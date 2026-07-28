import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keymory_off/core/router/app_router.dart';
import 'package:keymory_off/features/unlock/presentation/screens/unlock_screen.dart';
import 'package:keymory_off/l10n/app_localizations.dart';

void main() {
  testWidgets('starts at /unlock and displays UnlockScreen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: appRouter,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );

    expect(appRouter.state.uri.path, '/unlock');
    expect(find.byType(UnlockScreen), findsOneWidget);
  });
}
