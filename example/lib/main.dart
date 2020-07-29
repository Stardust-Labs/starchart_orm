import 'package:flutter/material.dart';
import 'main.reflectable.dart';
import './storage/dog.dart';
import 'package:starchart_orm/starchart_orm.dart';
import './widgets/dogs_app.dart';

main() async {
  initializeReflectable();
  WidgetsFlutterBinding.ensureInitialized();

  await Storage.init(DatabaseConfig(
      dbPath: 'dog.db', version: 1, driver: StorageDriver.sqflite), [Dog()]);

  await Dog().seed();

  List<Dog> dogs = await Dog().all();

  runApp(DogsApp(dogs: dogs));
}
