import 'package:flutter/material.dart';
import 'CreateChatRoom.dart';
import 'firestore/AuthService.dart';
import 'Main.dart';

void main() {
  runApp(MaterialApp(
    title: 'Project BAI',
    home: MenuRoute(),
  ));
}

class MenuRoute extends StatelessWidget {


  _singOutAndBackToLogIn (BuildContext context){
    authService.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeRoute()),
    );
  }

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
              MaterialButton(
                onPressed: () => _singOutAndBackToLogIn(context),
                color: Colors.red,
                textColor: Colors.white,
                child: Text('Sign out'),
              ),
            ],
          ),
        ));
  }
}
