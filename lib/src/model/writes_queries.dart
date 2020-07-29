import 'package:reflectable/mirrors.dart';
import 'package:starchart_orm/src/model/column.dart';
import 'package:starchart_orm/src/model/database_model.dart';
import 'package:starchart_orm/src/model/query_exception.dart';

mixin WritesQueries {
  Map<FieldType, String> _sqliteTypes = {
    FieldType.boolean: 'INTEGER',
    FieldType.integer: 'INTEGER',
    FieldType.float: 'REAL',
    FieldType.number: 'REAL',
    FieldType.real: 'REAL',
    FieldType.string: 'TEXT',
    FieldType.text: 'TEXT'
  };

  /// Returns a query string used by the sqflite driver's init function
  /// to generate a table for a DatabaseModel.  Throws [QueryException]
  /// if the instance does not have a proper table name or if it has no
  /// defined columns.
  String get createTableIfNotExistsSqlite {
    String query = 'CREATE TABLE IF NOT EXISTS ';
    ClassMirror classMirror = DefinesTable.reflectType(this.runtimeType);
    InstanceMirror instance = DefinesTable.reflect(this);

    if (instance.invokeGetter('table') == '') {
      throw QueryException(
          'No table is defined for class ' + this.runtimeType.toString());
    }
    if (classMirror.declarations.values
            .where((value) =>
                value.metadata.where((tag) => tag is Column).length == 1
            ).length == 0) {
      throw QueryException(
          this.runtimeType.toString() + ' does not define any Columns');
    }

    query += instance.invokeGetter('table');
    query += ' (id INTEGER PRIMARY KEY';

    classMirror.declarations.values.forEach((value) {
      // Add value to query if it's a defined, non-erroneous collumn
      if (value.metadata.where((tag) => tag is Column).length == 1) {
        Column column = value.metadata.where((tag) => tag is Column).first;
        String columnQuery = ', ';
        columnQuery += value.simpleName + ' ';
        columnQuery += _sqliteTypes[column.type];
        if (!column.isNullable) {
          columnQuery += ' NOT NULL';
        }
        if (column.isUnique) {
          columnQuery += ' UNIQUE';
        }
        query += columnQuery;
      }
    });
    query += ')';

    return query;
  }
}
