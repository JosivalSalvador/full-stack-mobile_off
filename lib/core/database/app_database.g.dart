// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class VaultMetadata extends Table
    with TableInfo<VaultMetadata, VaultMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  VaultMetadata(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _saltMeta = const VerificationMeta('salt');
  late final GeneratedColumn<String> salt = GeneratedColumn<String>(
    'salt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [id, salt, passwordHash, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vault_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<VaultMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('salt')) {
      context.handle(
        _saltMeta,
        salt.isAcceptableOrUnknown(data['salt']!, _saltMeta),
      );
    } else if (isInserting) {
      context.missing(_saltMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VaultMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VaultMetadataData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      salt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}salt'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  VaultMetadata createAlias(String alias) {
    return VaultMetadata(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class VaultMetadataData extends DataClass
    implements Insertable<VaultMetadataData> {
  final int id;
  final String salt;
  final String passwordHash;
  final int createdAt;
  const VaultMetadataData({
    required this.id,
    required this.salt,
    required this.passwordHash,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['salt'] = Variable<String>(salt);
    map['password_hash'] = Variable<String>(passwordHash);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  VaultMetadataCompanion toCompanion(bool nullToAbsent) {
    return VaultMetadataCompanion(
      id: Value(id),
      salt: Value(salt),
      passwordHash: Value(passwordHash),
      createdAt: Value(createdAt),
    );
  }

  factory VaultMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VaultMetadataData(
      id: serializer.fromJson<int>(json['id']),
      salt: serializer.fromJson<String>(json['salt']),
      passwordHash: serializer.fromJson<String>(json['password_hash']),
      createdAt: serializer.fromJson<int>(json['created_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'salt': serializer.toJson<String>(salt),
      'password_hash': serializer.toJson<String>(passwordHash),
      'created_at': serializer.toJson<int>(createdAt),
    };
  }

  VaultMetadataData copyWith({
    int? id,
    String? salt,
    String? passwordHash,
    int? createdAt,
  }) => VaultMetadataData(
    id: id ?? this.id,
    salt: salt ?? this.salt,
    passwordHash: passwordHash ?? this.passwordHash,
    createdAt: createdAt ?? this.createdAt,
  );
  VaultMetadataData copyWithCompanion(VaultMetadataCompanion data) {
    return VaultMetadataData(
      id: data.id.present ? data.id.value : this.id,
      salt: data.salt.present ? data.salt.value : this.salt,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VaultMetadataData(')
          ..write('id: $id, ')
          ..write('salt: $salt, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, salt, passwordHash, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VaultMetadataData &&
          other.id == this.id &&
          other.salt == this.salt &&
          other.passwordHash == this.passwordHash &&
          other.createdAt == this.createdAt);
}

class VaultMetadataCompanion extends UpdateCompanion<VaultMetadataData> {
  final Value<int> id;
  final Value<String> salt;
  final Value<String> passwordHash;
  final Value<int> createdAt;
  const VaultMetadataCompanion({
    this.id = const Value.absent(),
    this.salt = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  VaultMetadataCompanion.insert({
    this.id = const Value.absent(),
    required String salt,
    required String passwordHash,
    required int createdAt,
  }) : salt = Value(salt),
       passwordHash = Value(passwordHash),
       createdAt = Value(createdAt);
  static Insertable<VaultMetadataData> custom({
    Expression<int>? id,
    Expression<String>? salt,
    Expression<String>? passwordHash,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (salt != null) 'salt': salt,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  VaultMetadataCompanion copyWith({
    Value<int>? id,
    Value<String>? salt,
    Value<String>? passwordHash,
    Value<int>? createdAt,
  }) {
    return VaultMetadataCompanion(
      id: id ?? this.id,
      salt: salt ?? this.salt,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (salt.present) {
      map['salt'] = Variable<String>(salt.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaultMetadataCompanion(')
          ..write('id: $id, ')
          ..write('salt: $salt, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final VaultMetadata vaultMetadata = VaultMetadata(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [vaultMetadata];
}

typedef $VaultMetadataCreateCompanionBuilder =
    VaultMetadataCompanion Function({
      Value<int> id,
      required String salt,
      required String passwordHash,
      required int createdAt,
    });
typedef $VaultMetadataUpdateCompanionBuilder =
    VaultMetadataCompanion Function({
      Value<int> id,
      Value<String> salt,
      Value<String> passwordHash,
      Value<int> createdAt,
    });

class $VaultMetadataFilterComposer
    extends Composer<_$AppDatabase, VaultMetadata> {
  $VaultMetadataFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get salt => $composableBuilder(
    column: $table.salt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $VaultMetadataOrderingComposer
    extends Composer<_$AppDatabase, VaultMetadata> {
  $VaultMetadataOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get salt => $composableBuilder(
    column: $table.salt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $VaultMetadataAnnotationComposer
    extends Composer<_$AppDatabase, VaultMetadata> {
  $VaultMetadataAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get salt =>
      $composableBuilder(column: $table.salt, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $VaultMetadataTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          VaultMetadata,
          VaultMetadataData,
          $VaultMetadataFilterComposer,
          $VaultMetadataOrderingComposer,
          $VaultMetadataAnnotationComposer,
          $VaultMetadataCreateCompanionBuilder,
          $VaultMetadataUpdateCompanionBuilder,
          (
            VaultMetadataData,
            BaseReferences<_$AppDatabase, VaultMetadata, VaultMetadataData>,
          ),
          VaultMetadataData,
          PrefetchHooks Function()
        > {
  $VaultMetadataTableManager(_$AppDatabase db, VaultMetadata table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $VaultMetadataFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $VaultMetadataOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $VaultMetadataAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> salt = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
              }) => VaultMetadataCompanion(
                id: id,
                salt: salt,
                passwordHash: passwordHash,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String salt,
                required String passwordHash,
                required int createdAt,
              }) => VaultMetadataCompanion.insert(
                id: id,
                salt: salt,
                passwordHash: passwordHash,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $VaultMetadataProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      VaultMetadata,
      VaultMetadataData,
      $VaultMetadataFilterComposer,
      $VaultMetadataOrderingComposer,
      $VaultMetadataAnnotationComposer,
      $VaultMetadataCreateCompanionBuilder,
      $VaultMetadataUpdateCompanionBuilder,
      (
        VaultMetadataData,
        BaseReferences<_$AppDatabase, VaultMetadata, VaultMetadataData>,
      ),
      VaultMetadataData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $VaultMetadataTableManager get vaultMetadata =>
      $VaultMetadataTableManager(_db, _db.vaultMetadata);
}
