import 'package:flutter_test/flutter_test.dart';
import 'package:keymory_off/core/logging/app_logger.dart';

void main() {
  group('AppLogger', () {
    test('info does not throw', () {
      expect(() => AppLogger.info('Test message'), returnsNormally);
    });

    test('info with data does not throw', () {
      expect(
        () => AppLogger.info('Test message', data: {'key': 'value'}),
        returnsNormally,
      );
    });

    test('warning does not throw', () {
      expect(() => AppLogger.warning('Test warning'), returnsNormally);
    });

    test('error does not throw', () {
      expect(() => AppLogger.error('Test error'), returnsNormally);
    });

    test('error with an Exception and stack trace does not throw', () {
      expect(
        () => AppLogger.error(
          'Test error',
          error: Exception('boom'),
          stackTrace: StackTrace.current,
        ),
        returnsNormally,
      );
    });
  });
}
