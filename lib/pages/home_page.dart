import 'package:finstagram/pages/feed_page.dart';
import 'package:finstagram/pages/profile_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _listOfWidgets = [
    FeedPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finstagram"),
        backgroundColor: Colors.black,
        actions: [
          GestureDetector(child: const Icon(Icons.add_a_photo)),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: GestureDetector(
              child: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNavigatorBar(),
      body: _listOfWidgets[_currentIndex],
    );
  }

  Widget _bottomNavigatorBar() {
    return BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(label: "feed", icon: Icon(Icons.feed)),
          BottomNavigationBarItem(
            label: "profile",
            icon: Icon(Icons.account_box),
          )
        ]);
  }
}
