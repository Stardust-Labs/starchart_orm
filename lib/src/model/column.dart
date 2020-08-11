/// List of valid field types which can be converted
/// to the types supported by various storage drivers
enum FieldType {
  /// Correlates to the Dart `int` type
  integer,

  /// Correlates to the Dart `string` type and typically
  /// comes with a character limit depending on driver
  string,

  /// Correlates to the Dart `string` type and typically
  /// does not limit size in drivers that support the type
  text,

  /// Correlates to the Dart `bool` type, or to a Dart `int`
  /// or `num` with a value of 0 or 1.
  boolean,

  /// Correlates to the Dart `double` and `num` types
  float,

  /// Correlates to the Dart `double` and `num` types
  real,

  /// Correlates to the Dart `double` and `num` types
  number
}

/// Annotates a field for a subclass of DatabaseModel that is annotated
/// with DefinesTable and declares that the field should be represented
/// in the storage model.
class Column {
  const Column(this.type, {this.isUnique = false, this.isNullable = false});
  final FieldType type;

  /// If true, will prevent more than one record having the same
  /// value for this model
  final bool isUnique;

  /// If true, does not require a value to save or update
  final bool isNullable;
}
