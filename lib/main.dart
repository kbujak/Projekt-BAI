import 'package:flutter/material.dart';
import 'signin.dart';

void main() {
  runApp(MaterialApp(
    title: 'Project BAI',
    home: HomeRoute(),
  ));
}

class HomeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
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
            ),
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
