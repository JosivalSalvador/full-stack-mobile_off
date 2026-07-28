import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// The app's local SQLite database, managing the vault's configuration.
@DriftDatabase(include: {'tables/vault_metadata.drift'})
class AppDatabase extends _$AppDatabase {
  /// Creates the production [AppDatabase], persisting to a file in the
  /// device's application documents directory.
  AppDatabase() : super(_openConnection());

  /// Creates an [AppDatabase] backed by the given [e] (an in-memory
  /// connection, typically), for use in tests only.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'keymory.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
