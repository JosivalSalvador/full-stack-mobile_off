// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Keymory';

  @override
  String get unlockScreenTitle => 'Vault Locked';

  @override
  String get unlockButtonLabel => 'Unlock with biometrics';

  @override
  String get unlockInProgress => 'Authenticating...';

  @override
  String get unlockFailed => 'Authentication failed. Try again.';

  @override
  String get unlockBiometricsUnavailable =>
      'Biometrics not available on this device.';
}
