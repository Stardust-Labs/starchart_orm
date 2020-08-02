import 'package:starchart_orm/src/database/storage.dart';

import 'package:starchart_orm/src/model/mappable.dart';
import 'package:starchart_orm/src/model/model_props.dart';
import 'package:starchart_orm/src/model/query_props.dart';

import 'package:reflectable/reflectable.dart';
import 'package:starchart_orm/src/model/writes_queries.dart';

export 'package:starchart_orm/src/model/on_conflict_behavior.dart';
export 'package:starchart_orm/src/model/column.dart';

/// Enables reflection for DatabaseModels so that they can be converted
/// back and forth between maps
class DefinesTableReflector extends Reflectable {
  const DefinesTableReflector()
      : super(invokingCapability, staticInvokeCapability,
            declarationsCapability, metadataCapability);
}

/// Classes that extend DatabaseModel must have this constant as metadata
const DefinesTable = DefinesTableReflector();

/// Given a class `c` that represents a database model, `c` must:
/// * extend DatabaseModel with itself as the generic type, eg
///   `class C extends DatabaseModel<C>`
/// * have the `@DefinesTable` metadata annotation
/// * have an integer `id` field annotated with 
///   `@Column(FieldType.integer, isNullable: true)`
/// * implement the `table` field with a string
abstract class DatabaseModel<T> extends Mappable with QueryProps, ModelProps, WritesQueries {
  /// Insert or update the model as needed
  Future<void> save() async {
    if (id == null) {
      id = await Storage.insert(this);
    } else {
      Storage.update(this);
    }
  }

  /// Populates the `@Column` annotated fields of this 
  /// instance from a given [map]
  fromMap<T extends DatabaseModel> (Map<String, dynamic> map) {
    return generateFromMap<T>(map) as T;
  }

  /// Returns an instance of class `T` populated from the storage record
  /// with the provided [id].  Throws a [DatabaseException] if storage has
  /// not been initialized.  
  /// 
  /// Wraps the `find` method of the active storage driver.
  Future<T> find(int id) async {
    return await Storage.find(this, id) as T;
  }

  /// Returns the first record in the model's `table`, sorted by `id`
  /// ascending.  Throws a [DatabaseException] if storage has not been
  /// initialized.
  /// 
  /// Wraps `first` method of the active storage driver.
  Future<T> first() async {
    return await Storage.first(this);
  }

  /// Returns the last record in the model's `table`, sorted by `id`
  /// descending.  Throws a [DatabaseException] if storage has not been
  /// initialized.
  /// 
  /// Wraps the `last` method of the active storage driver.
  Future<T> last() async {
    return await Storage.last(this);
  }

  /// Returns a list of records in the model's `table`, sorted by id
  /// ascending, where properties given in [args] are equal.  Throws a 
  /// [DatabaseException] if storage has not been initialized.
  /// 
  /// Wraps the `where` method of the active storage driver.
  Future<List<T>> where(Map<String, dynamic> args) async {
    return await Storage.where(this, args);
  }

  /// Returns the first record in the model's `table`, sorted by id
  /// ascending, where properties given in [args] are equal.  Throws a 
  /// [DatabaseException] if storage has not been initialized.
  /// 
  /// Wraps the `firstWhere` method of the active storage driver.
  Future<T> firstWhere(Map<String, dynamic> args) async {
    return await Storage.firstWhere(this, args);
  }

  /// Returns the last record in the model's `table`, sorted by id
  /// ascending, where properties given in [args] are equal.  Throws a 
  /// [DatabaseException] if storage has not been initialized.
  /// 
  /// Wraps `lastWhere` method of the active storage driver.
  Future<T> lastWhere(Map<String, dynamic> args) async {
    return await Storage.lastWhere(this, args);
  }

  /// Returns all records in the model's `table`.  Throws a [DatabaseException] 
  /// if storage has not been initialized.
  /// 
  /// Wraps the `all` method of the active storage driver.
  Future<List<T>> all() async {
    return await Storage.all(this);
  }

  /// Deletes the model from its `table`, based on id.  Throws a 
  /// [DatabaseException] if storage has not been initialized.
  /// 
  /// Wraps the `delete` method of the active storage driver.
  Future<void> delete() async {
    await Storage.delete(this);
    id = null;
  }
}
