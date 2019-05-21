import 'package:flutter/material.dart';
import 'SignIn.dart';
import 'SingInAnonymousWidget.dart';
import 'firestore/AuthService.dart';
import 'Menu.dart';

void main() {
  runApp(MaterialApp(
    title: 'Menu',
    home: HomeRoute(),
  ));
}

class HomeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: authService.getCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Home();
          }
          else{
            return Scaffold(
            appBar: AppBar(
              title: Text('First Route'),
            ),
            body: TypeOfUserMenu(),
          );}
        });
  }
}

class TypeOfUserMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text('Welcome to MAKK chat'),
          RaisedButton(
            child: Text('User'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInWidget()),
              );
            },
          ),
          RaisedButton(
            child: Text('Guest'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SingInAnonymousWidget()),
              );
            },
          ),
        ],
      ),
    );
  }
}
