// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Keymory';

  @override
  String get unlockScreenTitle => 'Cofre Travado';

  @override
  String get unlockButtonLabel => 'Destravar com biometria';

  @override
  String get unlockInProgress => 'Autenticando...';

  @override
  String get unlockFailed => 'Falha na autenticação. Tente novamente.';

  @override
  String get unlockBiometricsUnavailable => 'Biometria não disponível neste dispositivo.';
}
