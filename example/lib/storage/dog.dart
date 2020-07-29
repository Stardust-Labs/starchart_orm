import 'package:starchart_orm/starchart_orm.dart';

@DefinesTable
class Dog extends DatabaseModel<Dog> {
  @Column(FieldType.integer, isNullable: true)
  int id;

  @Column(FieldType.string, isUnique: true)
  String name;

  @Column(FieldType.integer)
  int age;

  String table = 'dogs';

  @override
  OnConflictBehavior get onConflictBehavior => OnConflictBehavior.ignore;

  Future<void> seed() async {
    Dog dog1 = Dog().fromMap({'name': 'Mac', 'age': 15});
    Dog dog2 = Dog().fromMap({'name': 'Chica', 'age': 5});
    Dog dog3 = Dog().fromMap({'name': 'Buster', 'age': 12});
    Dog dog4 = Dog().fromMap({'name': 'Bailey', 'age': 8});
    await dog1.save();
    await dog2.save();
    await dog3.save();
    await dog4.save();
  }
}
