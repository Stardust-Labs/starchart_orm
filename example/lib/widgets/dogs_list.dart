import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/dog_model.dart';
import '../storage/dog.dart';

/// Home page, displays [Dog] list
class DogsList extends StatelessWidget {
  Widget _buildDogs() {
    return ScopedModelDescendant<DogModel>(builder: (context, child, model) {
      return ListView.builder(
          itemCount: model.dogs.length * 2,
          itemBuilder: (context, i) {
            if (i.isOdd) return Divider();

            final index = (i ~/ 2);
            return _buildDogRow(context, model.dogs[index], index);
          });
    });
  }

  Widget _buildDogRow(BuildContext context, Dog dog, index) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: ListTile(
        contentPadding: EdgeInsets.all(16.00),
        title: Text('${dog.id}: ${dog.name}, age ${dog.age}',
            style: TextStyle(fontSize: 18)),
        leading: FaIcon(FontAwesomeIcons.dog,
            color: index.isOdd ? Colors.red : Colors.blue),
      ),
      actions: <Widget>[
        IconSlideAction(
            caption: 'Update',
            color: Colors.greenAccent,
            icon: FontAwesomeIcons.upload,
            onTap: () => _promptUpdate(context, dog.id))
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: FontAwesomeIcons.trash,
          onTap: () => _promptDelete(context, dog.id)
        )
      ],
    );
  }

  Future<void> _promptUpdate(BuildContext context, int id) async {
    DogModel dogModel = DogModel.of(context);
    Dog dog = dogModel.dogs[dogModel.dogs.indexWhere((dog) => dog.id == id)];

    var ageController = TextEditingController();
    ageController.text = dog.age.toString();
    var nameController = TextEditingController();
    nameController.text = dog.name;

    return await showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update ${dog.name}'),
            content: Column(
              children: <Widget>[
                Text('Name', style: TextStyle(fontSize: 14.0)),
                TextField(
                    controller: nameController,
                    maxLines: 1,
                    decoration: InputDecoration(hintText: 'Name')),
                Text('Age', style: TextStyle(fontSize: 14.0)),
                TextField(
                    controller: ageController,
                    maxLines: 1,
                    decoration: InputDecoration(hintText: 'Age'))
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop()),
              FlatButton(
                  child: Text('Save'),
                  onPressed: () {
                    int age = int.parse(ageController.text);
                    String name = nameController.text.trim();
                    dogModel.updateDog(dog.id, name, age);
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  Future<void> _promptDelete(BuildContext context, id) async {
    DogModel dogModel = DogModel.of(context);
    Dog dog = dogModel.dogs[dogModel.dogs.indexWhere((dog) => dog.id == id)];

    return await showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete ${dog.name}?'),
            content: SingleChildScrollView(
              child: Text('This cannot be undone'),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                  child: Text('Do it.'),
                  onPressed: () {
                    dogModel.slaughterDog(dog);
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  Future<void> _addDog(BuildContext context) async {
    int age;
    String name;
    DogModel model = DogModel.of(context);

    var ageController = TextEditingController();
    var nameController = TextEditingController();

    return await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add a new Dog'),
            content: Column(
              children: <Widget>[
                Text('Name', style: TextStyle(fontSize: 14.0)),
                TextField(
                    controller: nameController,
                    maxLines: 1,
                    decoration: InputDecoration(hintText: 'Name')),
                Text('Age', style: TextStyle(fontSize: 14.0)),
                TextField(
                    controller: ageController,
                    maxLines: 1,
                    decoration: InputDecoration(hintText: 'Age'))
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop()),
              FlatButton(
                  child: Text('Save'),
                  onPressed: () {
                    age = int.parse(ageController.text);
                    name = nameController.text.trim();
                    model.addDog(name, age);
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hello Dogs')),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[new Expanded(child: _buildDogs())],
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _addDog(context),
          tooltip: 'New Dog',
          child: Icon(Icons.add)),
    );
  }
}
