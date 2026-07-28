import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:keymory_off/core/utils/date_formatter.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
    await initializeDateFormatting('pt');
  });

  group('formatDate', () {
    final timestamp = DateTime.utc(2026, 7, 27, 12).millisecondsSinceEpoch;

    test('formats a timestamp in English', () {
      const formatter = DateFormatter('en');

      final result = formatter.formatDate(timestamp);

      expect(result, contains('2026'));
    });

    test('formats a timestamp in Portuguese', () {
      const formatter = DateFormatter('pt');

      final result = formatter.formatDate(timestamp);

      expect(result, contains('2026'));
      expect(result, contains('julho'));
    });
  });
}
