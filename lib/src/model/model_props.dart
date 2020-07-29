import 'package:starchart_orm/src/database/storage_contract.dart';

@DefinesTable
mixin ModelProps {
  /// ID must be overridden and extended as a Column with [Fieldtype.integer]
  /// and [isNullable] = true.
  int id;

  /// Must be implemented with private property
  String get table;
}
