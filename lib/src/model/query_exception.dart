import 'package:starchart_orm/src/model/model_exception.dart';

/// Thrown when an exception occurs due to a database query
class QueryException extends ModelException {
  String message;

  QueryException([this.message]);
}
