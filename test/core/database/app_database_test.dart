import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keymory_off/core/database/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
  });

  tearDown(() async {
    await database.close();
  });

  group('vaultMetadata', () {
    test('starts empty', () async {
      final result = await database.select(database.vaultMetadata).get();
      expect(result, isEmpty);
    });

    test('stores and retrieves a row', () async {
      await database.into(database.vaultMetadata).insert(
            VaultMetadataCompanion.insert(
              salt: 'test-salt',
              passwordHash: 'test-hash',
              createdAt: 1000,
            ),
          );

      final result = await database.select(database.vaultMetadata).get();

      expect(result, hasLength(1));
      expect(result.first.salt, 'test-salt');
      expect(result.first.passwordHash, 'test-hash');
      expect(result.first.createdAt, 1000);
    });
  });
}
