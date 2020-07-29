/// The database drivers available for Starchart's storage.
enum StorageDriver { 
  /// sqflite is a SQLite plugin for Flutter with support for
  /// iOs, Android, and MacOS.
  sqflite, 
  /// sembast is a nosql persistent store database solution for
  /// single process io applications.  This driver does not provide
  /// cross process safety with the sembast_sqflite package.
  /// This driver does not provide web sembast_web web support.
  sembast 
}

/// Configuration details for the data layer.  An instance of
/// DatabaseConfig must be passed to the `init` method of the 
/// Storage class to initialize the ORM.
class DatabaseConfig {
  /// The database [version], used for migrations
  final num version;

  /// The String path for the database, ie 'example.db'
  final String dbPath;

  /// The [StorageDriver] which will power the data layer
  final StorageDriver driver;

  const DatabaseConfig({this.version, this.dbPath, this.driver});
}
