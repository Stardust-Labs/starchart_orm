import 'package:starchart_orm/src/model/model_exception.dart';

class QueryException extends ModelException {
  String message;

  QueryException([this.message]);
}
