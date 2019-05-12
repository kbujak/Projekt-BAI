import 'package:flutter/material.dart';
import 'CreateChatRoom.dart';
import 'firestore/Repository.dart';

void main() {
  runApp(MaterialApp(
    title: 'Project BAI',
    home: MenuRoute(),
  ));
}

class MenuRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Project BAI'),
          backgroundColor: Colors.amber,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Menu '),
              RaisedButton(
                child: Text('Create chat room'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateChatRoom()),
                  );
                },
              ),
              RaisedButton(
                child: Text('Search for interesting topics'),
                onPressed: () {
                },
              ),
              RaisedButton(
                child: Text('Look for people around you'),
                onPressed: () {},
              ),
            ],
          ),
        ));
  }
}
