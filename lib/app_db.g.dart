// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_db.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDB {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDBBuilder databaseBuilder(String name) => _$AppDBBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDBBuilder inMemoryDatabaseBuilder() => _$AppDBBuilder(null);
}

class _$AppDBBuilder {
  _$AppDBBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDBBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDBBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDB> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDB();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDB extends AppDB {
  _$AppDB([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  LocationDao? _locationDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
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
            'CREATE TABLE IF NOT EXISTS `track_points` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `timestamp` TEXT, `lat` REAL, `lng` REAL, `accuracy` REAL, `speed` REAL, `speedAccuracy` REAL, `heading` REAL, `altitude` REAL, `floor` INTEGER, `isMoving` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  LocationDao get locationDao {
    return _locationDaoInstance ??= _$LocationDao(database, changeListener);
  }
}

class _$LocationDao extends LocationDao {
  _$LocationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _locationInsertionAdapter = InsertionAdapter(
            database,
            'track_points',
            (Location item) => <String, Object?>{
                  'id': item.id,
                  'timestamp': item.timestamp,
                  'lat': item.lat,
                  'lng': item.lng,
                  'accuracy': item.accuracy,
                  'speed': item.speed,
                  'speedAccuracy': item.speedAccuracy,
                  'heading': item.heading,
                  'altitude': item.altitude,
                  'floor': item.floor,
                  'isMoving':
                      item.isMoving == null ? null : (item.isMoving! ? 1 : 0)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Location> _locationInsertionAdapter;

  @override
  Future<Location?> getLastEntry() async {
    return _queryAdapter.query(
        'SELECT * FROM track_points ORDER BY id DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => Location(
            id: row['id'] as int?,
            timestamp: row['timestamp'] as String?,
            lat: row['lat'] as double?,
            lng: row['lng'] as double?,
            accuracy: row['accuracy'] as double?,
            speed: row['speed'] as double?,
            speedAccuracy: row['speedAccuracy'] as double?,
            heading: row['heading'] as double?,
            altitude: row['altitude'] as double?,
            floor: row['floor'] as int?,
            isMoving: row['isMoving'] == null
                ? null
                : (row['isMoving'] as int) != 0));
  }

  @override
  Future<List<Location>?> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM track_points',
        mapper: (Map<String, Object?> row) => Location(
            id: row['id'] as int?,
            timestamp: row['timestamp'] as String?,
            lat: row['lat'] as double?,
            lng: row['lng'] as double?,
            accuracy: row['accuracy'] as double?,
            speed: row['speed'] as double?,
            speedAccuracy: row['speedAccuracy'] as double?,
            heading: row['heading'] as double?,
            altitude: row['altitude'] as double?,
            floor: row['floor'] as int?,
            isMoving: row['isMoving'] == null
                ? null
                : (row['isMoving'] as int) != 0));
  }

  @override
  Future<List<Location>?> getAllUnMapMatchedLocations() async {
    return _queryAdapter.queryList(
        'SELECT * FROM track_points WHERE isMatched == 0',
        mapper: (Map<String, Object?> row) => Location(
            id: row['id'] as int?,
            timestamp: row['timestamp'] as String?,
            lat: row['lat'] as double?,
            lng: row['lng'] as double?,
            accuracy: row['accuracy'] as double?,
            speed: row['speed'] as double?,
            speedAccuracy: row['speedAccuracy'] as double?,
            heading: row['heading'] as double?,
            altitude: row['altitude'] as double?,
            floor: row['floor'] as int?,
            isMoving: row['isMoving'] == null
                ? null
                : (row['isMoving'] as int) != 0));
  }

  @override
  Future<List<Location>?> getAllMapMatchedLocations() async {
    return _queryAdapter.queryList(
        'SELECT * FROM track_points WHERE isMatched == 1',
        mapper: (Map<String, Object?> row) => Location(
            id: row['id'] as int?,
            timestamp: row['timestamp'] as String?,
            lat: row['lat'] as double?,
            lng: row['lng'] as double?,
            accuracy: row['accuracy'] as double?,
            speed: row['speed'] as double?,
            speedAccuracy: row['speedAccuracy'] as double?,
            heading: row['heading'] as double?,
            altitude: row['altitude'] as double?,
            floor: row['floor'] as int?,
            isMoving: row['isMoving'] == null
                ? null
                : (row['isMoving'] as int) != 0));
  }

  @override
  Future<void> clear() async {
    await _queryAdapter.queryNoReturn('Delete FROM track_points');
  }

  @override
  Future<void> insert(Location location) async {
    await _locationInsertionAdapter.insert(
        location, OnConflictStrategy.replace);
  }
}
