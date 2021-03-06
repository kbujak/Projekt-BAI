import 'package:flutter/material.dart';
import 'CreateChatRoom.dart';
import 'firestore/AuthService.dart';
import 'Main.dart';
import 'SearchPeople.dart';
import 'ActiveChats.dart';
import 'SearchTags.dart';

enum MenuState {
  Status,
  Chats,
  Interests,
  Tags,
  People,
}

void main() {
  runApp(MaterialApp(
    title: 'Project BAI',
    home: Home(),
  ));
}

class PlaceholderWidget extends StatelessWidget {
  final MenuState menuState;

  PlaceholderWidget(this.menuState);

  @override
  Widget build(BuildContext context) {
    if (menuState == MenuState.Status) {
      return CreateChatRoom();
    } else {
      return Container(
        child: Text(menuState.toString()),
      );
    }
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    CreateChatRoom(),
    ActiveChatsWidget(),
    SearchTagsWidget(),
    SearchPeopleWidget(),
    Container()
  ];

  _singOutAndGoToMain() {
    authService.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeRoute()),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (_currentIndex == 4) {
      _singOutAndGoToMain();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.add_comment),
            title: Text('Start'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            title: Text('Chats'),
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
              icon: Icon(Icons.remove_circle), title: Text('Logout'))
        ],
      ),
    );
  }
}
