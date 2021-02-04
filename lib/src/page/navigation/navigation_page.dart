import 'package:flutter/material.dart';
import 'package:yen/src/page/chat/chat_page.dart';
import 'package:yen/src/page/home/home_page.dart';
import 'package:yen/src/page/member/member_page.dart';
import 'package:yen/src/page/post/post_page.dart';
import 'package:yen/src/page/profile/profile_page2.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ProfilePage2(),
    PostPage(),
    MemberPage(),
    ChatPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'HOME',
            // title: Text('HOME'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'PROFILE',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_comment),
            label: 'POST',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'MEMBER',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'CHAT',
          ),
        ],
        currentIndex: _selectedIndex,
        elevation: 8,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Color(0xff007EC4),
        onTap: _onItemTapped,
      ),
    );
  }
}
