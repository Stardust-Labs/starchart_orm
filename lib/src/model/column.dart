/// List of valid field types which can be converted
/// to the types supported by various storage drivers
enum FieldType { integer, string, text, boolean, float, real, number }

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
