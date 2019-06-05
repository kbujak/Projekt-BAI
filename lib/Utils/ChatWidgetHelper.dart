import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/Chat.dart';
import '../ChatPage.dart';

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
                reverse: false,
                itemBuilder: (_, int index) {
                  DocumentSnapshot document = snapshot.data.documents[index];

                  Chat chat = Chat(
                      document.documentID,
                      document.data["creator"].toString(),
                      document.data["name"].toString(),
                      List.from(document.data["tags"]),
                      List.from(document.data["members"])
                  );

                  return createChatItem(chat, user, context);
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

Widget createChatItem(Chat chat, FirebaseUser user, BuildContext context) {
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
            color: Color.fromRGBO(0, 135, 147, 1.0),
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
                Expanded(
                    child: Text(
                      "Tags: ${createTags(chat.tags)}"
                    )
                ),
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