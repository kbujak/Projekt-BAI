import 'package:flutter/material.dart';
import 'firestore/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/Menu.dart';

enum FormType { login, register }

class LogInWidget extends StatefulWidget {
  /*LogInWidget({this.auth});
  final AuthService auth;*/

  @override
  State<StatefulWidget> createState() => new _LogInWidget();
}

class _LogInWidget extends State<LogInWidget> {
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();
  String _email;
  String _password;
  FormType _formType;
  bool _isLoading;

  @override
  void initState() {
    _formType = FormType.login;
    _isLoading = false;
    super.initState();
  }

  _LogInWidget() {
    _emailController.addListener(_emailListen);
    _passwordController.addListener(_passwordListen);
  }

  void _emailListen() {
    if (_emailController.text.isEmpty) {
      _email = "";
    } else {
      _email = _emailController.text;
    }
  }

  void _passwordListen() {
    if (_passwordController.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordController.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FlutterBase',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Project BAI'),
            backgroundColor: Colors.amber,
          ),
          body: new Form(
            // padding: EdgeInsets.all(16.0),
            child: new ListView(children: <Widget>[
              new Column(
                children: <Widget>[
                  _showBody(),
                  _showPrimaryButton(),
                  _showCircularProgress(),
                ],
              ),
            ]),
          ),
        ));
  }

  Widget _showBody() {
    return Column(children: <Widget>[
      Center(child: Text("Log in to chat:")),
      Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
          controller: _emailController,
          decoration: new InputDecoration(
              hintText: 'E-mail',
              icon: new Icon(
                Icons.account_circle,
                color: Colors.blueAccent,
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
          validator:
              validateEmail, //(value) => value.isEmpty ? 'Login can\'t be empty' : null,
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          obscureText: true,
          controller: _passwordController,
          decoration: new InputDecoration(
              hintText: 'Password',
              icon: new Icon(
                Icons.lock,
                color: Colors.blueAccent,
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
          validator: (value) =>
              value.isEmpty ? 'Password can\'t be empty' : null,
        ),
      ),
    ]);
  }

  Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: new RaisedButton(
          elevation: 5.0,
          color: Colors.blue,
          child: new Text('Log in',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: _validateAndSubmit,
        ));
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'E-mail address is invalid!';
    else
      return null;
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  _validateAndSubmit() async {
    setState(() {
      _isLoading = true;
    });
    try {
      FirebaseUser user= await authService.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);
      print('Signed in: ${user.displayName}');
      goToMenu(context);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      var dialog = AlertDialog(
        title: Text('Something went wrong!'),
        content: Text(e.toString()),
      );
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return dialog;
          });
    }
  }

  void goToMenu(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MenuRoute()),
    );
  }
}
