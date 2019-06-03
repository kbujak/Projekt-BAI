import 'package:flutter/material.dart';
import 'firestore/AuthService.dart';
import 'package:my_app/Menu.dart';

class SingInAnonymousWidget extends StatefulWidget {
  const SingInAnonymousWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SingInAnonymousWidgetState();
}

class SingInAnonymousWidgetState extends State<SingInAnonymousWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: authService.getCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Home();
          } else
            return Scaffold(
                appBar: AppBar(
                  title: Text('Log In Anonymously'),
                  backgroundColor: Color.fromRGBO(0, 135, 147, 1.0),
                ),
                body: new ListView(children: <Widget>[
                  new Form(
                    key: _formKey,
                    child: new Column(
                      children: <Widget>[
                        _createAnonymousForm(),
                        _showLogInButton(),
                      ],
                    ),
                  ),
                ]),
            );
        });
  }

  Widget _createAnonymousForm() {
    return new Column(children: <Widget>[
      Padding(padding: EdgeInsets.only(top: 30)),
      Center(
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          margin: new EdgeInsets.only(top: 20, left: 30, right: 30),
          child: new Container(
              decoration: new BoxDecoration(
                color: Color.fromRGBO(0, 135, 147, 1.0),
                borderRadius: new BorderRadius.all(new Radius.circular(10)),
              ),
              constraints: new BoxConstraints(
                minHeight: 180.0,
              ),
              child: new Column(children: <Widget>[
                new Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "Please, provide your temporary nickname:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                    ),
                  ),
                ),
                new Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelText: 'Nickname',
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
                          ),
                          validator: (String value) {
                            if (value.trim().isEmpty) {
                              return 'Nickname can' 't be empty!';
                            }
                          },
                        ))),
              ])),
        ),
      )
    ]);
  }

  Widget _showLogInButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: ButtonTheme(
          minWidth: 200,
          height: 50,
          child: RaisedButton(
            elevation: 5.0,
            color: Color.fromRGBO(0, 77, 122, 1.0),
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            child: new Text('Log in',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: _validateAndSubmitAnonymous,
          )
        )
        );
  }

  _validateAndSubmitAnonymous() async {
    if (_formKey.currentState.validate()) {
      try {
        _formKey.currentState.save();
        var user = await authService.signInAnonymously();
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

  void goToMenu(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }
}
