import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keymory_off/core/database/app_database.dart';
import 'package:keymory_off/features/unlock/data/vault_repository.dart';

void main() {
  late AppDatabase database;
  late VaultRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(
      drift.DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    repository = VaultRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('hasVault', () {
    test('returns false when no vault has been created', () async {
      final result = await repository.hasVault();
      expect(result, isFalse);
    });

    test('returns true after a vault has been saved', () async {
      await repository.saveVaultMetadata(
        salt: 'test-salt',
        passwordHash: 'test-hash',
        createdAt: 1000,
      );

      final result = await repository.hasVault();
      expect(result, isTrue);
    });
  });

  group('getVaultMetadata', () {
    test('returns null when no vault has been created', () async {
      final result = await repository.getVaultMetadata();
      expect(result, isNull);
    });

    test('returns the saved data after saving', () async {
      await repository.saveVaultMetadata(
        salt: 'test-salt',
        passwordHash: 'test-hash',
        createdAt: 1000,
      );

      final result = await repository.getVaultMetadata();

      expect(result, isNotNull);
      expect(result!.salt, 'test-salt');
      expect(result.passwordHash, 'test-hash');
      expect(result.createdAt, 1000);
    });
  });

  group('saveVaultMetadata', () {
    test('overwrites the existing row instead of creating a new one', () async {
      await repository.saveVaultMetadata(
        salt: 'first-salt',
        passwordHash: 'first-hash',
        createdAt: 1000,
      );

      await repository.saveVaultMetadata(
        salt: 'second-salt',
        passwordHash: 'second-hash',
        createdAt: 2000,
      );

      final allRows = await database.select(database.vaultMetadata).get();

      expect(allRows, hasLength(1));
      expect(allRows.first.salt, 'second-salt');
    });
  });
}
