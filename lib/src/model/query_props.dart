import 'package:reflectable/mirrors.dart';
import 'package:sqflite/sqflite.dart';
import 'package:starchart_orm/src/model/database_model.dart';
import 'package:starchart_orm/src/model/on_conflict_behavior.dart';

export 'package:starchart_orm/src/model/on_conflict_behavior.dart';

mixin QueryProps {
  List<String> get uniqueConstraints {
    List<String> constraints = [];
    ClassMirror classMirror = DefinesTable.reflectType(this.runtimeType);
    classMirror.declarations.values.forEach((value) {
      if (value.metadata.where((tag) => tag is Column).length == 1) {
        Column tag = value.metadata.where((tag) => tag is Column).first;
        if (tag.isUnique) {
          constraints.add(value.simpleName);
        }
      }
    });
    return constraints;
  }

  OnConflictBehavior get onConflictBehavior => OnConflictBehavior.abort;

  /// Converts ORM [OnConflictBehavior] to [ConflictAlgorithm]
  /// for SQFlite insert calls
  ConflictAlgorithm get insertConflictAlgorithm {
    switch (onConflictBehavior) {
      case (OnConflictBehavior.rollback):
        return ConflictAlgorithm.rollback;
        break;
      case (OnConflictBehavior.abort):
        return ConflictAlgorithm.abort;
        break;
      case (OnConflictBehavior.fail):
        return ConflictAlgorithm.fail;
        break;
      case (OnConflictBehavior.ignore):
        return ConflictAlgorithm.ignore;
        break;
      case (OnConflictBehavior.replace):
        return ConflictAlgorithm.replace;
        break;
      default:
        return ConflictAlgorithm.abort;
    }
  }
}
