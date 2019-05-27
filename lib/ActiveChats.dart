import 'package:flutter/material.dart';
import 'firestore/Repository.dart';
import 'firestore/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Utils/ChatWidgetHelper.dart';

class ActiveChatsWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => ActiveChatsState();
}


class ActiveChatsState extends State<ActiveChatsWidget> {

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
    return user == null ?
    Text("User not authenticated") :
    Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Text(
                "Chat rooms you participate",
                style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0)
            ),
            createChatsUI(
                user,
                repository.getChatsByParticipatory(user.uid),
                "You haven't parcipated in any chat"
            ),
            SizedBox(height: 15),
            Text(
                "Chat rooms you created",
                style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0)
            ),
            createChatsUI(user,
                repository.getChatsByCreator(user.uid),
                "You haven't created in any chat"
            ),
          ],
        ),
      ),
    );
  }
}