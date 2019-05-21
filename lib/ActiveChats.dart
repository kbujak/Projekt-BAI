import 'package:flutter/material.dart';
import 'firestore/Repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'model/Chat.dart';
import 'ChatPage.dart';

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

  Flexible createChatsUI(FirebaseUser user, Stream<QuerySnapshot> stream, String failedText) {
    return Flexible(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 70),
          child: new StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  padding: new EdgeInsets.all(8),
                  reverse: true,
                  itemBuilder: (_, int index) {
                    DocumentSnapshot document = snapshot.data.documents[index];

                    Chat chat = Chat(
                        document.documentID,
                        document.data["creator"].toString(),
                        document.data["name"].toString(),
                        List.from(document.data["tags"]),
                        List.from(document.data["members"])
                    );

                    return createChatItem(chat);
                  },
                  itemCount: snapshot.data.documents.length,
                );
              } else {
                return Text(failedText);
              }
            },
          ),
        )
    );
  }

  Widget createChatItem(Chat chat) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                    user.email,
                    chat.id)),
          );
          print(chat.id);
          print(user.email);
        },
        child: Container(
            decoration: new BoxDecoration(
              color: Colors.amber,
              borderRadius: new BorderRadius.all(Radius.circular(10.0)),
            ),
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Column(
              children: <Widget>[
                Row(children: <Widget>[SizedBox(width: 10),Text("Name: ${chat.name}")]),
                SizedBox(height: 15),
                Row(children: <Widget>[
                  SizedBox(width: 10),
                  Text("Tags: ${createTags(chat.tags)}")
                ]),
                SizedBox(height: 15),
                Row(children: <Widget>[
                  SizedBox(width: 10),
                  Text("Number of users: ${chat.members.length}")
                ]),
              ],
            ))
    );
  }

  String createTags(List<String> tags) {
    return (tags.isNotEmpty && tags[0] != "") ? "#" + tags.reduce((acc, tag) => acc + " #$tag") : "";
  }
}