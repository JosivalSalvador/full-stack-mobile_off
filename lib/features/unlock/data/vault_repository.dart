import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';

/// Provides access to the vault's configuration row (salt, password hash,
/// and creation timestamp) stored in [AppDatabase].
///
/// This table holds exactly zero or one row: there is only ever a single
/// vault per device.
class VaultRepository {
  VaultRepository(this._database);

  final AppDatabase _database;

  /// Returns the current vault metadata, or `null` if no vault has been
  /// created yet.
  Future<VaultMetadataData?> getVaultMetadata() {
    return _database.select(_database.vaultMetadata).getSingleOrNull();
  }

  /// Creates or replaces the vault metadata row with the given [salt],
  /// [passwordHash], and [createdAt] (a Unix timestamp in milliseconds).
  Future<void> saveVaultMetadata({
    required String salt,
    required String passwordHash,
    required int createdAt,
  }) {
    return _database.into(_database.vaultMetadata).insertOnConflictUpdate(
          VaultMetadataCompanion.insert(
            id: const Value(1),
            salt: salt,
            passwordHash: passwordHash,
            createdAt: createdAt,
          ),
        );
  }

  /// Whether a vault has already been created on this device.
  Future<bool> hasVault() async {
    final metadata = await getVaultMetadata();
    return metadata != null;
  }
}