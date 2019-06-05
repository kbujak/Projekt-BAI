import 'package:flutter/material.dart';
import 'firestore/Repository.dart';
import 'ChatPage.dart';
import 'model/User.dart';
import 'firestore/AuthService.dart';

class CreateChatRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retrieve Text Input',
      home: MyCustomForm(),
    );
  }
}

// Define a Custom Form Widget
class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class. This class will hold the data related to
// our Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!
  final chatName = TextEditingController();
  final tags = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    chatName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create chat"),
        backgroundColor: Color.fromRGBO(0, 135, 147, 1.0),
      ),
      body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: chatName,
                  decoration: InputDecoration(
                      hintText: "Chat name",
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                  ),
                )
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: tags,
                    decoration: InputDecoration(
                        hintText: "Enter tags",
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                    ),
                  )
              )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          repository.saveChat(chatName.text, tags.text.split(" ")).then((r){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                      r.userEmail.toString(),
                      r.chatId.toString())),
            );
          });
        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.add),
      ),
    );
  }
}
