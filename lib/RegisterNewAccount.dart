import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firestore/AuthService.dart';
import 'Menu.dart';

class RegisterNewAccount extends StatefulWidget {
  const RegisterNewAccount({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterNewAccountState();
}

class _RegisterNewAccountState extends State<RegisterNewAccount> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _auth = new AuthService(); //FirebaseAuth.instance
  bool _agreedToTOS = true;
  String _name;
  String _email;
  String _nickname;
  String _password;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FlutterBase',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text('Project BAI'),
            backgroundColor: Colors.amber,
          ),
          body: ListView(children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                      child: Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child:
                        Text("Registration:", style: TextStyle(fontSize: 15.0)),
                  )),
                  new Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlue),
                          ),
                        ),
                        validator: (String value) {
                          if (value.trim().isEmpty) {
                            return 'Name is required!';
                          }
                        },
                        onSaved: (value) => _name = value,
                      )),
                  new Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              labelText: 'E-mail',
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightBlue))),
                          validator: (String value) {
                            if (value.trim().isEmpty) {
                              return 'E-mail is required!';
                            }
                          },
                          onSaved: (value) => _email = value)),
                  new Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Nickname',
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightBlue))),
                          validator: (String value) {
                            if (value.trim().isEmpty) {
                              return 'Nickname is required!';
                            }
                          },
                          onSaved: (value) => _nickname = value)),
                  new Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightBlue))),
                          validator: (String value) {
                            if (value.trim().isEmpty) {
                              return 'Password is required!';
                            }
                          },
                          onSaved: (value) => _password = value)),
                  Row(children: <Widget>[
                    Flexible(
                        child: Checkbox(
                      value: _agreedToTOS,
                      onChanged: _setAgreedToTOS,
                    )),
                    Flexible(
                        child: GestureDetector(
                      onTap: () => _setAgreedToTOS(!_agreedToTOS),
                      child: Wrap(
                        children: <Widget>[
                          Text(
                            'I agree to the Terms of Services and Privacy Policy',
                          ),
                        ],
                      ),
                    )),
                  ]),
                  Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Row(
                      children: <Widget>[
                        const Spacer(),
                        OutlineButton(
                          highlightedBorderColor: Colors.black,
                          color: Colors.green,
                          onPressed: _submittable() ? _submit : null,
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ));
  }

  bool _submittable() {
    return _agreedToTOS;
  }

  void _submit() async {
    if (_formKey.currentState.validate()) {
      try {
        _formKey.currentState.save();
        FirebaseUser user = await _auth.createUserWithEmailAndPassword(_email, _password);
        print('Registered user : ${user.uid}');
        goToMenu(context);
      } catch (ex) {
        var dialog = AlertDialog(
          title: Text('Something went wrong!'),
          content: Text(ex.toString()),
        );
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return dialog;
            });
      }
    }
  }

  void _setAgreedToTOS(bool newValue) {
    setState(() {
      _agreedToTOS = newValue;
    });
  }

  void goToMenu(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }
}
