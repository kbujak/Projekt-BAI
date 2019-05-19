import 'package:flutter/material.dart';
import 'package:my_app/firestore/AuthService.dart';
import 'Menu.dart';
import 'package:location/location.dart';
import 'firestore/Repository.dart';

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
                  MaterialButton(
                    onPressed: () => authService.signOut(),
                    color: Colors.red,
                    textColor: Colors.white,
                    child: Text('Sign out'),
                  ),
                  UserProfile() // <-- Built with StatefulWidget
                ],
              ),
            )));
  }
}

class UserProfile extends StatefulWidget {
  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  Map<String, dynamic> _profile;
  bool _loading = false;


  Location location = Location();
  Map<String, double> currentLocation;

  @override
  initState() {
    super.initState();
    location.onLocationChanged().listen((value) {
      setState(() {
        print('LOCATION CHANGED');
        currentLocation = value;
        repository.updatePosition(currentLocation["latitude"].toString(), currentLocation["longitude"].toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          currentLocation == null
              ? CircularProgressIndicator()
              : Text("Location:" + currentLocation["latitude"].toString() + " " + currentLocation["longitude"].toString()),
        ],
      );
  }
}

class LoginButton extends StatelessWidget {
  void goToMenu(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
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
