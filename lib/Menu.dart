import 'package:flutter/material.dart';
import 'CreateChatRoom.dart';
import 'firestore/AuthService.dart';
import 'Main.dart';
import 'firestore/Repository.dart';


void main() {
  runApp(MaterialApp(
    title: 'Project BAI',
    home: Home(),
  ));
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}

class Home extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home>{
  int _currentIndex = 0;

  final List<Widget> _children = [
    CreateChatRoom(),
    PlaceholderWidget(Colors.deepOrange),
    PlaceholderWidget(Colors.green),
    PlaceholderWidget(Colors.blueAccent),
    PlaceholderWidget(Colors.brown),
    PlaceholderWidget(Colors.cyanAccent),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  _singOutAndBackToLogIn (BuildContext context){
    authService.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeRoute()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Project BAI'),
          backgroundColor: Colors.amber,
        ),
        body: /*Center(
          child: Column(
            children: <Widget>[
              Text('Menu '),
              RaisedButton(
                child: Text('Create chat room'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateChatRoom()),
                  );
                },
              ),
              RaisedButton(
                child: Text('Search for interesting topics'),
                onPressed: () {
                },
              ),
              RaisedButton(
                child: Text('Look for people around you'),
                onPressed: () {},
              ),
              MaterialButton(
                onPressed: () => _singOutAndBackToLogIn(context),
                color: Colors.red,
                textColor: Colors.white,
                child: Text('Sign out'),
              ),
            ],
          ),
        )*/
        _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Status'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            title: Text('Chats'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            title: Text('Interests'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            title: Text('Tags'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('People'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.remove_circle),
              title: Text('Logout'))
        ],
      ),
    );
  }
}
