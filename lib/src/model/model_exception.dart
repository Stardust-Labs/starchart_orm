/// Thrown when an exception occurs in a DatabaseModel function
class ModelException implements Exception {
  String message;
  ModelException([this.message]);
}
