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
            body: TypeOfUserMenu(),
          );}
        });
  }
}

class TypeOfUserMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.1, 0.5, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Color.fromRGBO(5, 25, 55, 1.0),
              Color.fromRGBO(0, 77, 122, 1.0),
              Color.fromRGBO(0, 135, 147, 1.0),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome to MAKK chat',
                textAlign: TextAlign.center,
                style: new TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70
                ),
              ),
              SizedBox(height: 30),
              ButtonTheme(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                minWidth: 300,
                height: 50,
                child: RaisedButton(
                  color: Colors.white70,
                  child: Text(
                    'User',
                    style: new TextStyle(
                        fontSize: 20
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInWidget()),
                    );
                  },
                ),
              ),
              SizedBox(height: 15),
              ButtonTheme(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                minWidth: 300,
                height: 50,
                child: RaisedButton(
                  color: Colors.white70,
                  child: Text(
                    'Guest',
                    style: new TextStyle(
                        fontSize: 20
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SingInAnonymousWidget()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
