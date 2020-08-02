import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:starchart_orm/src/database/storage_contract.dart';
import 'package:starchart_orm/src/model/database_model.dart';
import 'package:starchart_orm/starchart_orm.dart';
import 'package:starchart_orm/src/database/database_config.dart';

/// A driver for [Storage] built on sqflite
class SqfliteDriver extends StorageContract {
  //@protected
  DatabaseConfig config;

  /// Constructs the path for the application database
  Future<String> constructPath() async {
    return join(await getDatabasesPath(), config.dbPath);
  }

  /// Initalize the database at startup.
  @override
  Future<Database> init(
      DatabaseConfig userConfig, List<DatabaseModel> registeredModels) async {
    config = userConfig;
    return await openDatabase(await constructPath(),
        onCreate: (db, version) => _initializeTables(db, registeredModels),
        version: config.version);
  }

  /// Returns an open [Database] connection
  Future<Database> open() async {
    return await openDatabase(await constructPath(), version: config.version);
  }

  /// Create database schema during [init]
  void _initializeTables(db, List<DatabaseModel> registeredModels) {
    // StructuredQuery.createTables.forEach((query) {
    //   db.execute(query);
    // });
    registeredModels.forEach((model) {
      db.execute(model.createTableIfNotExistsSqlite);
    });
  }

  /// [Insert] new record into table
  Future<int> insert(DatabaseModel dbModel) async {
    Database db = await open();
    return db.insert(dbModel.table, dbModel.toMap(),
        conflictAlgorithm: dbModel.insertConflictAlgorithm);
  }

  /// [Update] record in table
  Future<void> update(DatabaseModel dbModel) async {
    Database db = await open();
    db.update(dbModel.table, dbModel.toMap(),
        where: 'id = ?', whereArgs: [dbModel.id]);
  }

  /// [Find] record by id
  Future<T> find<T>(DatabaseModel dbModel, int id) async {
    Database db = await open();
    List<Map<String, dynamic>> maps = await db.query(dbModel.table,
        where: 'id = ?', whereArgs: [id], limit: 1);
    return dbModel.fromMap(maps.first) as T;
  }

  /// Get the [first] model from the database, by id
  Future<T> first<T>(DatabaseModel dbModel) async {
    Database db = await open();
    List<Map<String, dynamic>> maps = await db.query(dbModel.table, limit: 1);
    return dbModel.fromMap(maps.first) as T;
  }

  /// Get the [last] model from the database, by id
  Future<T> last<T>(DatabaseModel dbModel) async {
    Database db = await open();
    List<Map<String, dynamic>> maps =
        await db.query(dbModel.table, limit: 1, orderBy: 'id DESC');
    return dbModel.fromMap(maps.first) as T;
  }

  /// [Get] from the database [Where] [columns] = [args]
  Future<List<T>> where<T>(
      DatabaseModel dbModel, Map<String, dynamic> args) async {
    Database db = await open();
    Map<String, dynamic> whereStatements = _buildWhereStatements(args);

    List<Map<String, dynamic>> maps = await db.query(dbModel.table,
        where: whereStatements['where'], whereArgs: whereStatements['args']);
        
    return List.generate(maps.length, (index) {
      return dbModel.fromMap(maps[index]) as T;
    });
  }

  /// [Get] from the database the first record [Where] [columns] = [args]
  Future<T> firstWhere<T>(
      DatabaseModel dbModel, Map<String, dynamic> args) async {
    Database db = await open();
    Map<String, dynamic> whereStatements = _buildWhereStatements(args);

    List<Map<String, dynamic>> maps = await db.query(dbModel.table,
        where: whereStatements['where'],
        whereArgs: whereStatements['args'],
        limit: 1);
    return dbModel.fromMap(maps.first) as T;
  }

  /// [Get] from the database the last record [Where] [columns] = [args]
  Future<T> lastWhere<T>(
      DatabaseModel dbModel, Map<String, dynamic> args) async {
    Database db = await open();
    Map<String, dynamic> whereStatements = _buildWhereStatements(args);

    List<Map<String, dynamic>> maps = await db.query(dbModel.table,
        where: whereStatements['where'],
        whereArgs: whereStatements['args'],
        limit: 1,
        orderBy: 'id DESC');
    return dbModel.fromMap(maps.first) as T;
  }

  Map<String, dynamic> _buildWhereStatements(Map<String, dynamic> args) {
    String whereQuery = '';
    List<dynamic> whereArgs = [];
    args.forEach((column, arg) {
      whereQuery += '"$column" = ?, ';
      whereArgs.add(arg);
    });
    whereQuery = whereQuery.replaceAll(new RegExp(r', $'), '');

    return {'where': whereQuery, 'args': whereArgs};
  }

  /// Get [all] records from the table
  Future<List<T>> all<T>(DatabaseModel dbModel) async {
    Database db = await open();
    List<Map<String, dynamic>> maps = await db.query(dbModel.table);
    return List.generate(maps.length, (index) {
      return dbModel.fromMap(maps[index]) as T;
    });
  }

  /// [Delete] record from table
  Future<void> delete(DatabaseModel dbModel) async {
    Database db = await open();
    db.delete(dbModel.table, where: 'id = ?', whereArgs: [dbModel.id]);
  }
}
