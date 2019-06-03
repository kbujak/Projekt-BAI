import 'package:flutter/material.dart';
import 'package:my_app/firestore/AuthService.dart';
import 'Menu.dart';
import 'LogIn.dart';
import 'firestore/AuthService.dart';
import 'RegisterNewAccount.dart';
import 'dart:async';


class SignInWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: authService.getCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Home();
          }

          /// other way there is no user logged.
          return Scaffold(
                  appBar: AppBar(
                    title: Text('Log in'),
                    backgroundColor: Color.fromRGBO(0, 135, 147, 1.0),
                  ),
                  body: Center(
                    child: Column(
                      children: <Widget>[
                        LoginButton(), // <-- Built with StreamBuilder
                        UserProfile() // <-- Built with StatefulWidget
                      ],
                    ),
                  )
          );
        });
  }
}

class UserProfile extends StatefulWidget {
  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  Map<String, dynamic> _profile;
  bool _loading = false;
  bool isLocationKnown = false;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class LoginButton extends StatelessWidget {
  void goToMenu(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  void goToLogInForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LogInWidget()),
    );
  }

  void createNewAccount(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterNewAccount()));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: authService.user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MaterialButton(
              onPressed: () => goToMenu(context),
              color: Colors.red,
              textColor: Colors.white,
              child: Text('Go to menu'),
            );
          } else {
            return new Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 100)),
                ButtonTheme(
                    minWidth: 230,
                    height: 50,
                    child: MaterialButton(
                      elevation: 5.0,
                      color: Color.fromRGBO(0, 77, 122, 1.0),
                      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      child: Text(
                          'Log in',
                          style: new TextStyle(fontSize: 20.0, color: Colors.white)
                      ),
                      onPressed: () => goToLogInForm(context),
                    )
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                ButtonTheme(
                    minWidth: 230,
                    height: 50,
                    child: MaterialButton(
                      elevation: 5.0,
                      color: Color.fromRGBO(0, 77, 122, 1.0),
                      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      child: Text(
                          'Create new account',
                          style: new TextStyle(fontSize: 20.0, color: Colors.white)
                      ),
                      onPressed: () => createNewAccount(context),
                    )
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: ButtonTheme(
                        minWidth: 230,
                        height: 50,
                        child: MaterialButton(
                          elevation: 5.0,
                          color: Colors.primaries[0],
                          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          child: Text(
                              'Log In with Google',
                              style: new TextStyle(fontSize: 20.0, color: Colors.white)
                          ),
                          onPressed: () {
                            authService.googleSignIn().then((user) {
                              if (user != null) {
                                goToMenu(context);
                              }
                            });
                          },
                        )
                    ),
                ),
              ],
            );
          }
        });
  }
}
