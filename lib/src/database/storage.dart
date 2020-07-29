import 'package:meta/meta.dart';
import 'package:starchart_orm/src/database/database_config.dart';
import 'package:starchart_orm/src/database/database_exception.dart';
import 'package:starchart_orm/src/database/drivers/sembast_driver.dart';
import 'package:starchart_orm/src/database/drivers/sqflite_driver.dart';
import 'package:starchart_orm/src/model/database_model.dart';

export 'package:starchart_orm/src/database/database_config.dart';

/// This class provides abstract static access to the storage functions for
/// each storage driver that are guaranteed by the [StorageContract].
class Storage {
  @protected
  static DatabaseConfig config;
  static var storage;

  /// Initializes the [Storage] class for static access.
  ///
  /// Throws a [DatabaseException] if [registeredModels] is null or empty and
  /// required by the driver chosen in [config].  Passes through the return of
  /// the chosen driver's `init` method.
  static Future<dynamic> init(DatabaseConfig config,
      [List<DatabaseModel> registeredModels]) async {
    bool passesRegisteredModels = false;
    switch (config.driver) {
      // Initialize the sqflite driver for static access
      case StorageDriver.sqflite:
        passesRegisteredModels = true;

        if (registeredModels == null) {
          throw new DatabaseException(
              'sqflite driver requires a List of DatabaseModels to register');
        } else if (registeredModels.length == 0) {
          throw new DatabaseException(
              'registeredModels must contain at least one DatabaseModel');
        }

        storage = SqfliteDriver();
        break;

      // Initialize the sembast driver for static access
      case StorageDriver.sembast:
        storage = SembastDriver();
        break;
    }

    if (passesRegisteredModels) {
      return storage.init(config, registeredModels);
    } else {
      return storage.init(config, null);
    }
  }

  /// Throws a [DatabaseException] if any method is called on [Storage] before
  /// `init`.
  static void _abortIfUnitialized() {
    if (storage == null) {
      throw new DatabaseException('Storage is uninitialized.');
    }
  }

  /// Wraps the `open` method of the active storage driver.
  ///
  /// This is typically called by helper methods but is made available for the
  /// purpose of extending storage functionality.  Throws a [DatabaseException]
  /// if `init` has not been called.
  static Future<dynamic> open() async {
    _abortIfUnitialized();
    return storage.open();
  }

  /// Wraps the `insert` method of the active storage driver.
  ///
  /// Accesses the appropriate table or store via the given [dbModel].
  /// Returns an integer representing the key or id assigned by the insert.
  /// Throws a [DatabaseException] if `init` has not been called.
  static Future<int> insert(DatabaseModel dbModel) async {
    _abortIfUnitialized();
    return storage.insert(dbModel);
  }

  /// Wraps the `update` method of the active storage driver.
  ///
  /// Accesses the appropriate table or store via the given [dbModel].  Throws
  /// a [DatabaseException] if `init` has not been called.
  static Future<void> update(DatabaseModel dbModel) async {
    _abortIfUnitialized();
    return storage.update(dbModel);
  }

  /// Wraps the `find` method of the active storage driver.
  ///
  /// Returns the DatabaseModel in the table or store defined in [dbModel]
  /// with the key or id [id].  Throws a [DatabaseException] if `init` has not
  /// been called.
  static Future<T> find<T>(DatabaseModel dbModel, int id) async {
    _abortIfUnitialized();
    return storage.find<T>(dbModel, id);
  }

  /// Wraps the `first` method of the active storage driver.
  ///
  /// Returns the first DatabaseModel in the table or store defined in
  /// [dbModel], sorted by key or id ascending.  Throws a [DatabaseException]
  /// if `init` has not been called.
  static Future<T> first<T>(DatabaseModel dbModel) async {
    _abortIfUnitialized();
    return storage.first<T>(dbModel);
  }

  /// Wraps the `last` method of the active storage driver.
  ///
  /// Returns the last DatabaseModel in the table or store defined in
  /// [dbModel], sorted by key or id descending.  Throws a [DatabaseException]
  /// if `init` has not been called.
  static Future<T> last<T>(DatabaseModel dbModel) async {
    _abortIfUnitialized();
    return storage.last<T>(dbModel);
  }

  /// Wraps the `where` method of the active storage driver.
  ///
  /// Returns a List of DatabaseModel records in the table or store
  /// defined in [dbModel] where properties given in [args] are equal.  Throws a
  ///  [DatabaseException] if `init` has not been called.
  static Future<List<T>> where<T>(
      DatabaseModel dbModel, Map<String, dynamic> args) async {
    _abortIfUnitialized();
    return storage.where<T>(dbModel, args);
  }

  /// Wraps the `firstWhere` method of the active storage driver.
  ///
  /// Returns the first DatabaseModel in the table or store defined in
  /// [dbModel], sorted by key or id ascending, where properties given
  /// in [args] are equal.  Throws a [DatabaseException] if `init` has not been
  /// called.
  static Future<T> firstWhere<T>(
      DatabaseModel dbModel, Map<String, dynamic> args) async {
    _abortIfUnitialized();
    return storage.firstWhere<T>(dbModel, args);
  }

  /// Wraps the `lastWhere` method of the active storage driver.
  ///
  /// Returns the last DatabaseModel in the table or store defined in
  /// [dbModel], sorted by key or id descending, where properties given
  /// in [args] are equal.  Throws a [DatabaseException] if `init` has not been
  /// called.
  static Future<T> lastWhere<T>(
      DatabaseModel dbModel, Map<String, dynamic> args) async {
    _abortIfUnitialized();
    return storage.lastWhere<T>(dbModel, args);
  }

  /// Wraps the `all` method of the active storage driver.
  ///
  /// Returns a list of all DatabaseModel records in the table or store
  /// defined in [dbModel].  Throws a [DatabaseException] if `init` has not been
  ///  called.
  static Future<List<T>> all<T>(DatabaseModel dbModel) async {
    _abortIfUnitialized();
    return storage.all<T>(dbModel);
  }

  /// Wraps the `delete` method of the active storage driver.
  ///
  /// Deletes the [dbModel] from its table or store, based on key or id.  Throws
  ///  a [DatabaseException] if `init` has not been called.
  static Future<void> delete(DatabaseModel dbModel) async {
    _abortIfUnitialized();
    return storage.delete(dbModel);
  }
}
