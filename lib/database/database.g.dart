// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CartDao _cartDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CartEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `itemsInCart` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CartDao get cartDao {
    return _cartDaoInstance ??= _$CartDao(database, changeListener);
  }
}

class _$CartDao extends CartDao {
  _$CartDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _cartEntityInsertionAdapter = InsertionAdapter(
            database,
            'CartEntity',
            (CartEntity item) => <String, dynamic>{
                  'id': item.id,
                  'itemsInCart': item.itemsInCart
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CartEntity> _cartEntityInsertionAdapter;

  @override
  Future<List<CartEntity>> getGuestCart() async {
    return _queryAdapter.queryList('SELECT * FROM CartEntity',
        mapper: (Map<String, dynamic> row) =>
            CartEntity(row['id'] as int, row['itemsInCart'] as String));
  }

  @override
  Stream<CartEntity> findPersonById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM CartEntity WHERE id = ?',
        arguments: <dynamic>[id],
        queryableName: 'CartEntity',
        isView: false,
        mapper: (Map<String, dynamic> row) =>
            CartEntity(row['id'] as int, row['itemsInCart'] as String));
  }

  @override
  Future<void> clearCartEntity() async {
    return await _queryAdapter.queryNoReturn('DELETE FROM CartEntity');
    // return _queryAdapter.queryList('DELETE FROM CartEntity',
    //     mapper: (Map<String, dynamic> row) =>
    //         CartEntity(row['id'] as int, row['itemsInCart'] as String));
  }

  @override
  Future<void> addToGuestCart(CartEntity cartEntity) async {
    await _cartEntityInsertionAdapter.insert(
        cartEntity, OnConflictStrategy.abort);
  }
}
