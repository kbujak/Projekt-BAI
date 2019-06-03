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
        title: Text("Status"),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Text('chat name: '),
          TextField(
            controller: chatName,
          ),
          Text('tags: '),
          TextField(
            controller: tags,
          ),
          RaisedButton(
              child: Text('Go to chat'),
              onPressed: () {
                authService.getCurrentUser().then((user) {
                  print(user.toString());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatPage(
                            user.email.toString(),
                            //TODO for now hardcoded chat
                            "-LegksTMPdJ4omainO7p")),
                  );
                });
              })
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
