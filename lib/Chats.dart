import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore/AuthService.dart';
import 'model/Chat.dart';
import 'ChatPage.dart';
import 'Utils/ChatWidgetHelper.dart';

class ChatsWidget extends StatefulWidget {

  final Stream<QuerySnapshot> chatsQuery;
  final String tag;
  const ChatsWidget({ Key key, this.chatsQuery, this.tag}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChatsState();
}

class ChatsState extends State<ChatsWidget> {

  FirebaseUser user;

  @override
  void initState() {
    authService.getCurrentUser().then((firebaseUser) {
      setState(() {
        user = firebaseUser;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user != null && widget.chatsQuery != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.tag),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 40),
          child: Column(
            children: <Widget>[
              Text(
                  "Chats for tag: " + widget.tag,
                  style: TextStyle(fontSize: 25),
              ),
              createChatsUI(user, widget.chatsQuery, "No chat for given tag")
            ],
          ),
        ),
      );
    } else {
      return Center(child: Text("Not authorized"));
    }
  }
}