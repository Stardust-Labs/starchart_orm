import 'package:starchart_orm/src/database/storage.dart';

import 'package:starchart_orm/src/model/mappable.dart';
import 'package:starchart_orm/src/model/model_props.dart';
import 'package:starchart_orm/src/model/query_props.dart';

import 'package:reflectable/reflectable.dart';
import 'package:starchart_orm/src/model/writes_queries.dart';

export 'package:starchart_orm/src/model/on_conflict_behavior.dart';
export 'package:starchart_orm/src/model/column.dart';

class DefinesTableReflector extends Reflectable {
  const DefinesTableReflector()
      : super(invokingCapability, staticInvokeCapability,
            declarationsCapability, metadataCapability);
}

const DefinesTable = DefinesTableReflector();

abstract class DatabaseModel<T> extends Mappable with QueryProps, ModelProps, WritesQueries {
  /// Insert or update the model as needed
  Future<void> save() async {
    if (id == null) {
      id = await Storage.insert(this);
    } else {
      Storage.update(this);
    }
  }

  fromMap<T extends DatabaseModel> (Map<String, dynamic> map) {
    return generateFromMap<T>(map) as T;
  }

  /// Wrapper for the [Storage] find method
  Future<T> find(int id) async {
    return await Storage.find(this, id) as T;
  }

  /// Wrapper for the [Storage] first method
  Future<T> first() async {
    return await Storage.first(this);
  }

  /// Wrapper for the [Storage] last method
  Future<T> last() async {
    return await Storage.last(this);
  }

  /// Wrapper for the [Storage] where method
  Future<List<T>> where(Map<String, dynamic> args) async {
    return await Storage.where(this, args);
  }

  /// Wrapper for the [Storage] firstWhere method
  Future<T> firstWhere(Map<String, dynamic> args) async {
    return await Storage.firstWhere(this, args);
  }

  /// Wrapper for the [Storage] lastWhere method
  Future<T> lastWhere(Map<String, dynamic> args) async {
    return await Storage.lastWhere(this, args);
  }

  /// Wrapper for the [Storage] all method
  Future<List<T>> all() async {
    return await Storage.all(this);
  }

  /// [Delete] the model from the database
  Future<void> delete() async {
    await Storage.delete(this);
    id = null;
  }
}
