import 'package:flutter/material.dart';
import 'package:my_app/firestore/AuthService.dart';
import 'Menu.dart';


class SignInWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FlutterBase',
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
            )
        )
    );
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

    // Subscriptions are created here
    //authService.profile.listen((state) => setState(() => _profile = state));
    //authService.loading.listen((state) => setState(() => _loading = state));
    
    /*authService.profile.listen((data) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MenuRoute()),
        );
    }, onDone: () {
    }, onError: (error) {
      print("Some Error");
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      //Container(padding: EdgeInsets.all(20), child: Text(_profile.toString())),
      Text(_loading.toString())
    ]);
  }
}

class LoginButton extends StatelessWidget {

  void lol(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MenuRoute()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: authService.user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MaterialButton(
              onPressed: () => lol(context),
              color: Colors.red,
              textColor: Colors.white,
              child: Text('Go to menu'),
            );
          } else {
            return MaterialButton(
              onPressed: () => authService.googleSignIn(),
              color: Colors.white,
              textColor: Colors.black,
              child: Text('Login with Google'),
            );
          }
        });
  }
}