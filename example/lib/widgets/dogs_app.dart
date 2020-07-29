import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './dogs_list.dart';
import '../models/dog_model.dart';
import '../storage/dog.dart';

/// Root [Widget] for the application
class DogsApp extends StatelessWidget {
  DogsApp({this.dogs});
  final List<Dog> dogs;

  @override
  Widget build (BuildContext context) {
    return ScopedModel<DogModel> (
      model: DogModel(dogs: dogs),
      child: MaterialApp(
          title: 'Dogs Database App',
          home: DogsList()
        )
    );
  }
}