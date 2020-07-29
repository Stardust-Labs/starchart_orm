# starchart_orm

Storage-backed object relational mapping for Flutter applications.

## Getting Started

You will need to add `build_runner` to your Flutter app's dependencies.

Models should extend `DatabaseModel` with their own type, eg `class M extends DatabaseModel<M>`, and must be decorated with the `@DefinesTable` annotation.  They must also contain at least one field decorated with the `@Column()` annotation, and ideally should include a Column for `int id`.  Finally, a model must implement a field `String table` with a valid name for the store or table the model will use.

And example model would look like:

```dart
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
}
```

In your main function, you will need to initialize Storage with a valid DatabaseConfig object.  E.G.:

*Doesn't require model registration:*
```dart
main() async {
    var config = DatabaseConfig(
        dbPath: 'dogs.db',
        driver: StorageDriver.sembast,
        version: 1
    );
    await Storage.init(config);

    runApp(MyApp());
}
```

*Requires model registration:*
```dart
main() async {
    var config = DatabaseConfig(
        dbPath: 'dogs.db',
        driver: StorageDriver.sqflite,
        version: 1
    );
    List<DatabaseModel> registeredModels = [
        Dog()
    ];
    
    await Storage.init(config, registeredModels);

    runApp(MyApp());
}
```

## Available drivers

Starchart currently supports `sembast` and `sqflite` as its storage drivers.  The init for `sqflite` requires passing in any models to be added to the database.

## Implementation

In order to use models and storage, build_runner must be run in the directory containing your application's main function.  This will generate a file in that directory `[file_with_main_function].reflectable.dart`.  As per [the reflectable package](https://pub.dev/packages/reflectable), you will need to import that file into the file with your main function and call `initializeReflectable()` prior to initializing storage.

## Minimum use example
```dart
// File: main.dart
import 'package:flutter/material.dart';
import 'package:starchart_orm/starchart_orm.dart';
import 'main.reflectable.dart';

@DefinesTable
class Dog extends DatabaseModel<Dog> {
    /// DatabaseModel provides support for auto-incrementing IDs 
    /// that are provided by the storage driver, but requires that
    /// subclasses implement the id field and declare that it has
    /// an integer type and is nullable
    @Column(FieldType.integer, isNullable: true)
    int id;

    @Column(FieldType.string, isUnique: true)
    String name;

    @Column(FieldType.integer)
    int age;

    String table = 'dogs';
}

main async {
    initializeReflectable();
    WidgetsFlutterBinding.ensureInitialized();

    DatabaseConfig config = DatabaseConfig(
        dbPath: 'dogs.db',
        driver: StorageDriver.sqflite,
        version: 1
    );
    List<DatabaseModel> registeredModels = [
        Dog()
    ];

    await Storage.init(config, registeredModels);

    runApp(MyApp());
}

class MyApp 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter with Starchart'),
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
```

## Roadmap to 0.1.0
[ ] Add documentation
[ ] Add tests
[ ] Expand example to demonstrate all storage functions
- [ ] Save
- - [X] Insert
- - [ ] Update
- [ ] Find
- [ ] First
- [ ] Last
- [ ] Where
- [ ] First Where
- [ ] Last Where
- [X] All
- [X] Delete

## Roadmap to 1.0.0
[ ] Provide support for relationships
[ ] Provide support for upgrade migrations
[ ] Provide functionality to dump storage for retrieval or secondary storage
