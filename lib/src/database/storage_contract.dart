import 'package:starchart_orm/src/model/database_model.dart';
import 'package:starchart_orm/src/database/database_config.dart';

export 'package:starchart_orm/src/model/database_model.dart';

abstract class StorageContract {
  DatabaseConfig get config;
  Future<dynamic> init(
      DatabaseConfig config, List<DatabaseModel> registeredModels);
  Future<dynamic> open();
  Future<int> insert(DatabaseModel dbModel);
  Future<void> update(DatabaseModel dbModel);
  Future<T> find<T>(DatabaseModel dbModel, int id);
  Future<T> first<T>(DatabaseModel dbModel);
  Future<T> last<T>(DatabaseModel dbModel);
  Future<List<T>> where<T>(DatabaseModel dbModel, Map<String, dynamic> args);
  Future<T> firstWhere<T>(DatabaseModel dbModel, Map<String, dynamic> args);
  Future<T> lastWhere<T>(DatabaseModel dbModel, Map<String, dynamic> args);
  Future<List<T>> all<T>(DatabaseModel dbModel);
  Future<void> delete(DatabaseModel dbModel);
}
