import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'package:starchart_orm/src/database/storage_contract.dart';
import 'package:starchart_orm/starchart_orm.dart';

/// A driver for [Storage] built on sembast
class SembastDriver extends StorageContract {
  @protected
  DatabaseConfig config;

  /// Construct the [path] for the application database
  Future<String> constructPath() async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    return join(dir.path, config.dbPath);
  }

  /// Initialize the database at startup
  Future<Database> init(DatabaseConfig config, registeredModels) async {
    config = config;
    return open();
  }

  /// Return an open [Database] connection
  Future<Database> open() async {
    return await databaseFactoryIo.openDatabase(await constructPath());
  }

  /// [Insert] new record into table
  Future<int> insert(DatabaseModel dbModel) async {
    StoreRef store = intMapStoreFactory.store(dbModel.table);
    Database db = await open();

    // Check unique constraints
    if (dbModel.uniqueConstraints.length > 0) {
      Map<String, dynamic> modelMap = dbModel.toMap();
      Map<String, dynamic> queryArgs = {};
      dbModel.uniqueConstraints.forEach(
          (constraint) => queryArgs[constraint] = modelMap[constraint]);
      DatabaseModel uniqueCheck = await firstWhere(dbModel, queryArgs);
      if (uniqueCheck != null) {
        return null;
      }
    }

    int id;
    await db.transaction((txn) async {
      id = await store.add(txn, dbModel.toMap());
    });
    return id;
  }

  /// [Update] record in table
  Future<void> update(DatabaseModel dbModel) async {
    StoreRef store = intMapStoreFactory.store(dbModel.table);
    Database db = await open();
    await store.record(dbModel.id).update(db, dbModel.toMap());
  }

  /// [Find] record by id
  Future<T> find<T>(DatabaseModel dbModel, int id) async {
    StoreRef store = intMapStoreFactory.store(dbModel.table);
    Database db = await open();

    Map<String, dynamic> map = Map.from(await store.record(id).get(db));
    if (map == null) return null;

    map['id'] = id;
    return dbModel.fromMap(map) as T;
  }

  /// Get the [first] model from the store, by id
  Future<T> first<T>(DatabaseModel dbModel) async {
    StoreRef store = intMapStoreFactory.store(dbModel.table);
    Database db = await open();

    var record = await store.findFirst(db);
    if (record == null) return null;

    Map<String, dynamic> map = Map.from(record.value);
    map['id'] = record.key;
    return dbModel.fromMap(map) as T;
  }

  /// Get the [last] model from the store, by id
  Future<T> last<T>(DatabaseModel dbModel) async {
    StoreRef store = intMapStoreFactory.store(dbModel.table);
    Database db = await open();
    Finder finder = Finder(sortOrders: [SortOrder(Field.key, false)]);

    var record = await store.findFirst(db, finder: finder);
    if (record == null) return null;

    Map<String, dynamic> map = Map.from(record.value);
    map['id'] = record.key;
    return dbModel.fromMap(map) as T;
  }

  /// Get from the database where [columns] = [args]
  Future<List<T>> where<T>(
      DatabaseModel dbModel, Map<String, dynamic> args) async {
    StoreRef store = intMapStoreFactory.store(dbModel.table);
    Database db = await open();

    List<Filter> filters = [];
    args.forEach((column, arg) => filters.add(Filter.equals(column, arg)));
    Finder finder = Finder(filter: Filter.and(filters));

    var records = await store.find(db, finder: finder);
    if (records == null) return null;

    List<T> models = [];
    records.forEach((record) {
      Map<String, dynamic> map = Map.from(record.value);
      map['id'] = record.key;
      models.add(dbModel.fromMap(map) as T);
    });

    return models;
  }

  /// Get from the store the first record where [columns] = [args]
  Future<T> firstWhere<T>(
      DatabaseModel dbModel, Map<String, dynamic> args) async {
    StoreRef store = intMapStoreFactory.store(dbModel.table);
    Database db = await open();

    List<Filter> filters = [];
    args.forEach((column, arg) => filters.add(Filter.equals(column, arg)));
    Finder finder = Finder(filter: Filter.and(filters));

    var record = await store.findFirst(db, finder: finder);
    if (record == null) return null;

    Map<String, dynamic> map = Map.from(record.value);
    map['id'] = record.key;
    return dbModel.fromMap(record.value) as T;
  }

  /// Get from the store the last record where [columns] = [args]
  Future<T> lastWhere<T>(
      DatabaseModel dbModel, Map<String, dynamic> args) async {
    StoreRef store = intMapStoreFactory.store(dbModel.table);
    Database db = await open();

    List<Filter> filters = [];
    args.forEach((column, arg) => filters.add(Filter.equals(column, arg)));
    Finder finder = Finder(
        filter: Filter.and(filters), sortOrders: [SortOrder(Field.key, false)]);

    var record = await store.findFirst(db, finder: finder);
    if (record == null) return null;

    Map<String, dynamic> map = Map.from(record.value);
    map['id'] = record.key;
    return dbModel.fromMap(map) as T;
  }

  /// Get [all] records from the store
  Future<List<T>> all<T>(DatabaseModel dbModel) async {
    StoreRef store = intMapStoreFactory.store(dbModel.table);
    Database db = await open();

    var records = await store.find(db);
    if (records == null) return null;

    List<T> models = [];
    records.forEach((record) {
      Map<String, dynamic> map = Map.from(record.value);
      map['id'] = record.key;
      models.add(dbModel.fromMap(map) as T);
    });

    return models;
  }

  /// [Delete] record from table
  Future<void> delete(DatabaseModel dbModel) async {
    StoreRef store = intMapStoreFactory.store(dbModel.table);
    Database db = await open();
    Finder finder = Finder(filter: Filter.equals(Field.key, dbModel.id));

    store.delete(db, finder: finder);
  }
}
