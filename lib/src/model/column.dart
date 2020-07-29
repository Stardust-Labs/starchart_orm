enum FieldType { integer, string, text, boolean, float, real, number }

class Column {
  const Column(this.type, {this.isUnique = false, this.isNullable = false});
  final FieldType type;
  final bool isUnique;
  final bool isNullable;
}
