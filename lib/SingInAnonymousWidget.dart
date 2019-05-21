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
            return MaterialApp(
              title: 'FlutterBase',
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                appBar: AppBar(
                  title: Text('Project BAI'),
                  backgroundColor: Colors.amber,
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
              ),
            );
        });
  }

  Widget _createAnonymousForm() {
    return new Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text('Log in as anonymous user')),
      Center(
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          margin: new EdgeInsets.only(top: 20, left: 30, right: 30),
          child: new Container(
              decoration: new BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: new BorderRadius.all(new Radius.circular(10)),
              ),
              constraints: new BoxConstraints(
                minHeight: 180.0,
              ),
              child: new Column(children: <Widget>[
                new Padding(
                  padding: EdgeInsets.all(15.0),
                  child: new Text("Please, provide your temporary nickname:"),
                ),
                new Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                        color: Colors.white,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Nickname',
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
        child: new RaisedButton(
          elevation: 5.0,
          color: Colors.blue,
          child: new Text('Log in',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: _validateAndSubmitAnonymous,
        ));
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
