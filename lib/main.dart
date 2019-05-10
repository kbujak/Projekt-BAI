import 'package:flutter/material.dart';
import 'signin.dart';

void main() => runApp(HomeRoute());

class HomeRoute extends StatelessWidget {
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
              Text('Welcome to MAKK chat'),
              RaisedButton(
                child: Text('User'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
              ), // <-- Built with StreamBuilder
              RaisedButton(
                child: Text('Guest'),
                onPressed: () {
                },
              ),
            ],
          ),
        ));
  }

}
