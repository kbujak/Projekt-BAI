import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore/Repository.dart';
import 'model/User.dart';

class ChatInfo extends StatelessWidget {
  String roomId;

  ChatInfo(String roomId){
    this.roomId = roomId;
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: repository.getChatInfo(roomId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              decoration: new BoxDecoration(
                color: Color.fromRGBO(0, 135, 147, 1.0),
              ),
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(snapshot.data['name']),
                  Text(snapshot.data['tags'].toString()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Users: '),
                      Text((snapshot.data['members'] as List<dynamic>).length.toString())
                    ],
                  )
                ],
              ),
            );
          }
        });
  }

}

class ChatPage extends StatefulWidget {
  ChatPage(this._userName, this._roomId);

  final String _userName, _roomId;
  Map<String, User> members;

  @override
  _ChatPageState createState() => new _ChatPageState();
}



class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  Map<String, User> members = new Map();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        backgroundColor: Color.fromRGBO(0, 135, 147, 1.0),
      ),
        body: Container(
          child: Column(
            children: <Widget>[
              ChatInfo(widget._roomId),
              Flexible(
                  child: new StreamBuilder(
                stream: repository.getChatMessages(widget._roomId),
                builder: (context, snapshot1) {
                  return StreamBuilder(
                    stream: repository.getChatMembers(widget._roomId),
                    builder: (context, membersSnapshot) {
                      if (!snapshot1.hasData || !membersSnapshot.hasData
                      || snapshot1.data.documents.length == 0 || membersSnapshot.data.documents.length == 0){
                        return Container();
                      } else{
                        return new ListView.builder(
                          padding: new EdgeInsets.all(8.0),
                          reverse: true,
                          itemBuilder: (_, int index) {
                            DocumentSnapshot document =
                            snapshot1.data.documents[index];
                            membersSnapshot.data.documents.forEach((doc) {
                              members[doc['uid'].toString()] = User(doc['email'], doc['photoURL']);
                            });

                            bool isOwnMessage = false;
                            if (document['sender'] == widget._userName) {
                              isOwnMessage = true;
                            }
                            return isOwnMessage
                                ? _ownMessage(
                                document['message'],
                                document['sender'],
                                //document['photoUrl'],
                                members[document['senderId']].photoURL,
                                document['sent'].toString())
                                : _message(
                                document['message'],
                                document['sender'],
                                "https://image.freepik.com/free-vector/man-avatar-profile-round-icon_24640-14044.jpg",
                                //members[document['senderId']].photoURL,
                                document['sent'].toString());
                          },
                          itemCount: snapshot1.data.documents.length,
                        );
                      }
                    },
                  );
                },
              )),
              new Divider(height: 1.0),
              Container(
                margin: EdgeInsets.only(bottom: 20.0, right: 10.0, left: 10.0),
                child: Row(
                  children: <Widget>[
                    new Flexible(
                      child: new TextField(
                        controller: _controller,
                        //onSubmitted: _handleSubmit(),
                        decoration: new InputDecoration.collapsed(
                            hintText: "send message"),
                      ),
                    ),
                    new Container(
                      child: new IconButton(
                          icon: new Icon(
                            Icons.send,
                            color: Color.fromRGBO(0, 135, 147, 1.0),
                          ),
                          onPressed: () {

                            repository.addMessage(
                                widget._roomId, _controller.text);
                            _controller.text = "";
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }



  Widget _ownMessage(
      String message, String userName, String photoUrl, String sent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
            color: Colors.amber, //new Color.fromRGBO(255, 0, 0, 0.0),
            borderRadius: new BorderRadius.all(Radius.circular(20.0)),
          ),
          margin: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(photoUrl))),
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      width: 25.0,
                      height: 25.0,
                    ),
                    Text(userName),
                  ],
                ),
              ),
              Text(sent.substring(11, 16)),
              Text(message),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _message(
      String message, String userName, String photoUrl, String sent) {

    print(sent);
    return Row(
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: new BorderRadius.all(Radius.circular(20.0)),
          ),
          margin: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(photoUrl))),
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      width: 25.0,
                      height: 25.0,
                    ),
                    Text(userName),
                  ],
                ),
              ),
              Text(sent.substring(11, 16)),
              Text(message),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        )
      ],
    );
  }
}
