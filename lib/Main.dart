import 'package:flutter/material.dart';
import 'SignIn.dart';
import 'SingInAnonymousWidget.dart';
import 'firestore/AuthService.dart';

void main() {
  runApp(MaterialApp(
    title: 'Menu',
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
        body: TypeOfUserMenu(),
    );
  }
}


class TypeOfUserMenu extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authService.user,
      builder: (context, snapshot)
        {
          if(snapshot.hasData)
            {
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
                          MaterialPageRoute(builder: (context) => SingInAnonymousWidget()),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          else
            {
              return Text('User is already logged in!');
              //navigate back to menu
            }
        }

    );
  }

}
