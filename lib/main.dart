import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keymory_off/core/router/app_router.dart';
import 'package:keymory_off/core/theme/app_theme.dart';
import 'package:keymory_off/l10n/app_localizations.dart';

void main() {
  runApp(const ProviderScope(child: KeymoryApp()));
}

/// The root widget of the Keymory app.
///
/// Wires together the router, theme, and localization configuration built
/// throughout `lib/core`.
class KeymoryApp extends StatelessWidget {
  /// Creates the [KeymoryApp] root widget.
  const KeymoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
    );
  }
}
