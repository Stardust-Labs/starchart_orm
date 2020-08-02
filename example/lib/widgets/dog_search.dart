import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/dog_model.dart';

class DogSearch extends StatelessWidget {
  Widget _buildLookup(BuildContext context) {
    DogModel model = DogModel.of(context);

    model.search(model.searchTerm);

    return Column(
      children: <Widget>[
        Text('Search name', style: TextStyle(fontSize: 14.0)),
        TextField(
          maxLines: 1,
          decoration: InputDecoration(hintText: 'Name'),
          onChanged: (value) {
            model.search(value);
          },
        )
      ],
      mainAxisAlignment: MainAxisAlignment.start,
    );
  }

  Widget _buildFoundDogs() {
    return ScopedModelDescendant<DogModel>(builder: (context, child, model) {
      return ListView.builder(
          itemCount: model.searchedDogs.length * 2,
          itemBuilder: (context, i) {
            if (i.isOdd) return Divider();

            final index = (i ~/ 2);
            return _buildFoundDogRow(context, model.searchedDogs[index], index);
          });
    });
  }

  Widget _buildFoundDogRow(BuildContext context, Dog dog, index) {
    return ListTile(
        contentPadding: EdgeInsets.all(16.00),
        title: Text('${dog.id}: ${dog.name}, age ${dog.age}',
            style: TextStyle(fontSize: 18)),
        leading: FaIcon(FontAwesomeIcons.dog,
            color: index.isOdd ? Colors.red : Colors.blue));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Look For A Dog')),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildLookup(context),
            new Expanded(child: _buildFoundDogs())
          ],
        )));
  }
}
