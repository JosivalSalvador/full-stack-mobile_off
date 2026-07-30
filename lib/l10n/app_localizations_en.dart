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
  String get unlockErrorNoHardware =>
      'No biometrics or device PIN are set up on this device.';

  @override
  String get unlockErrorTooManyAttempts =>
      'Too many attempts. Try again later.';

  @override
  String get unlockErrorCancelled => 'Authentication was cancelled.';

  @override
  String get unlockErrorUnknown => 'Authentication failed. Try again.';
}
