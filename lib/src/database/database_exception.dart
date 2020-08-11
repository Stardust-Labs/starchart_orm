/// Thrown when a database driver is unable to complete
/// a transaction or initialization
class DatabaseException implements Exception {
  String message;

  DatabaseException([this.message]);
}
