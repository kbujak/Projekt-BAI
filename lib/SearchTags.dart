import 'package:flutter/material.dart';
import 'firestore/AuthService.dart';
import 'Chats.dart';
import 'firestore/Repository.dart';

class SearchTagsWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => SearchTagsState();
}

class SearchTagsState extends State<SearchTagsWidget> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Search tags",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Tags"),
          backgroundColor: Color.fromRGBO(0, 135, 147, 1.0),
        ),
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset : false,
        body: ListView(children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(40, 100, 40, 200),
            padding: EdgeInsets.only(top: 20),
            decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(Radius.circular(30.0)),
                color: Color.fromRGBO(0, 135, 147, 1.0)
            ),

            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "Please, enter keywords:",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,),
                SizedBox(height: 40.0),
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                          border: new OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Text("Search"),
                  onPressed: () {
                    authService.getCurrentUser().then((user) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatsWidget(chatsQuery: repository.getChatsByTag(_controller.text),
                                tag: _controller.text)
                        ),
                      );
                    });
                  },
                )
              ],
            ),
          ),
        ],)
      )
    );
  }
}