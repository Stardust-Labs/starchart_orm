import 'package:starchart_orm/src/model/database_model.dart';
import 'package:reflectable/reflectable.dart';
import 'package:starchart_orm/src/model/column.dart';
import 'package:meta/meta.dart';
import 'package:starchart_orm/src/model/model_exception.dart';

@DefinesTable
abstract class Mappable {
  /// Reflects the class and outputs a map whose keys and values
  /// are taken from the simpleName and gotten value for each value
  /// declared in the class that is annotated with the `@Column` metadata
  Map<String, dynamic> toMap() {
    ClassMirror classMirror = DefinesTable.reflectType(this.runtimeType);
    InstanceMirror instance = DefinesTable.reflect(this);

    Map<String, dynamic> map = {};
    classMirror.declarations.values.forEach((value) {
      if (value.metadata.where((tag) => tag is Column).length == 1) {
        map[value.simpleName] = instance.invokeGetter(value.simpleName);
      }
    });
    return map;
  }

  /// Reflects the instance's class and populates fields with the
  /// `@Column` metadata from a given [map] where the String key matches
  /// the simpleName of the annotated value
  @protected
  DatabaseModel generateFromMap<T extends DatabaseModel>(
      Map<String, dynamic> map) {
    ClassMirror classMirror = DefinesTable.reflectType(this.runtimeType);
    T model = classMirror.newInstance('', []) as T;
    InstanceMirror instance = DefinesTable.reflect(model);

    classMirror.declarations.values.forEach((value) {
      if (value.metadata.where((tag) => tag is Column).length == 1) {
        Column column = value.metadata.where((tag) => tag is Column).first;
        if (column.isNullable == false && map[value.simpleName] == null) {
          throw ModelException('Missing required field ${value.simpleName}');
        }
        instance.invokeSetter(value.simpleName, map[value.simpleName]);
      }
    });

    return model;
  }
}
