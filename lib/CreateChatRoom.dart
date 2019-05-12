import 'package:flutter/material.dart';
import 'firestore/Repository.dart';
import 'ChatPage.dart';

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
        title: Text('Create chat'),
        backgroundColor: Colors.amber,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatPage("realmadryt287@gmail.com", "-LefLjIgKuVrTlrFs5wa")),
                );
              })
        ],
      )),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog with the
        // text the user has typed into our text field.
        onPressed: () {
          repository.saveChat(chatName.text, tags.text.split(" "));
          /*return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the user has typed in using our
                // TextEditingController
                content: Text(chatName.text + tags.text),
              );
            },
          );*/
        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.add),
      ),
    );
  }
}
