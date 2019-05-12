import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore/Repository.dart';

class ChatPage extends StatefulWidget {
  ChatPage(this._userName, this._roomId);

  final String _userName, _roomId;

  @override
  _ChatPageState createState() => new _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("chat page"),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: <Widget>[
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: repository.getChatMessages(widget._roomId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return new ListView.builder(
                      padding: new EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) {
                        DocumentSnapshot document =
                            snapshot.data.documents[index];

                        print('HERE sender' + document['sender'].toString());
                        print('HERE message' + document['message'].toString());

                        bool isOwnMessage = false;
                        if (document['sender'] == widget._userName) {
                          isOwnMessage = true;
                        }
                        return isOwnMessage
                            ? _ownMessage(document['message'],
                                document['sender'], document['photoUrl'])
                            : _message(document['message'], document['sender'],
                                document['photoUrl']);
                      },
                      itemCount: snapshot.data.documents.length,
                    );
                  },
                ),
              ),
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
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            repository.addMessage(
                                widget._roomId, _controller.text);
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _ownMessage(String message, String userName, String photoUrl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Container(
              child: Image.network(photoUrl),
              width: 30.0,
              height: 30.0,
            ),
            Text(userName),
            Text(message),
          ],
        ),
      ],
    );
  }

  Widget _message(String message, String userName, String photoUrl) {
    return Row(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Container(
              child: Image.network(photoUrl),
              width: 30.0,
              height: 30.0,
            ),
            Text(userName),
            Text(message),
          ],
        )
      ],
    );
  }
}
