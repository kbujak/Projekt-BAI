import 'package:flutter/material.dart';
import 'package:my_app/firestore/AuthService.dart';
import 'Menu.dart';
import 'LogIn.dart';
import 'firestore/AuthService.dart';
import 'RegisterNewAccount.dart';

class SignInWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: authService.getCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return MenuRoute();
          }

          /// other way there is no user logged.
          return MaterialApp(
              title: 'FlutterBase',
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                  appBar: AppBar(
                    title: Text('Project BAI'),
                    backgroundColor: Colors.amber,
                  ),
                  body: Center(
                    child: Column(
                      children: <Widget>[
                        LoginButton(), // <-- Built with StreamBuilder
                        UserProfile() // <-- Built with StatefulWidget
                      ],
                    ),
                  )));
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

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[/*Text(_loading.toString())*/]);
  }
}

class LoginButton extends StatelessWidget {
  void goToMenu(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MenuRoute()),
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
                MaterialButton(
                  onPressed: () => goToLogInForm(context),
                  color: Colors.white,
                  textColor: Colors.black,
                  child: Text('Log in'),
                ),
                MaterialButton(
                  onPressed: () => createNewAccount(context),
                  color: Colors.white,
                  textColor: Colors.black,
                  child: Text('Create new account'),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: MaterialButton(
                      onPressed: () => authService.googleSignIn(),
                      color: Colors.blueAccent,
                      textColor: Colors.black,
                      child: Text('Login with Google'),
                    )),
              ],
            );
          }
        });
  }
}
