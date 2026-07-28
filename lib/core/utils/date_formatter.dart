import 'package:intl/intl.dart';

/// Converts the raw Unix timestamps stored in the database (as returned by
/// Drift's `INTEGER` columns) into human-readable, locale-aware strings.
class DateFormatter {
  /// Creates a [DateFormatter] for the given [localeName] (e.g. `'en'` or
  /// `'pt'`), matching the app's currently active locale.
  const DateFormatter(this.localeName);

  /// The locale used to format dates (e.g. `'en'`, `'pt'`).
  final String localeName;

/// Formats [millisecondsSinceEpoch] as a full, localized date, such as
  /// "July 27, 2026" (en) or "27 de julho de 2026" (pt).
  ///
  /// [millisecondsSinceEpoch] is assumed to be in UTC (as stored in the
  /// database), and is converted to the device's local time zone before
  /// formatting.
  String formatDate(int millisecondsSinceEpoch) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      millisecondsSinceEpoch,
      isUtc: true,
    ).toLocal();
    return DateFormat.yMMMMd(localeName).format(dateTime);
  }
}
