import 'dart:io';

import 'package:finstagram/pages/feed_page.dart';
import 'package:finstagram/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:finstagram/services/firebase_service.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  FirebaseService? _firebaseService;

  int _currentIndex = 0;
  final List<Widget> _listOfWidgets = [
    FeedPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finstagram"),
        backgroundColor: Colors.black,
        actions: [
          GestureDetector(
            onTap: _postImage,
            child: const Icon(Icons.add_a_photo),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: GestureDetector(
              onTap: () async {
                await _firebaseService!.logout();
                Navigator.popAndPushNamed(context, '/login');
              },
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
          BottomNavigationBarItem(
            label: "feed",
            icon: Icon(Icons.feed),
          ),
          BottomNavigationBarItem(
            label: "profile",
            icon: Icon(Icons.account_box),
          )
        ]);
  }

  void _postImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    File image = File(result!.files.first.path!);
    await _firebaseService!.postImage(image);
  }
}
