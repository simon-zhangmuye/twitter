import 'package:flutter/material.dart';
import 'package:twitter/pages/profile.dart';
import 'package:twitter/pages/twitter.dart';
import 'package:twitter/utils/variables.dart';

import 'pages/search.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageindex = 0;
  List pages = [
    Twitter(),
    Search(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageindex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            pageindex = index;
          });
        },
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.black,
        currentIndex: pageindex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 32,
              ),
              title: Text(
                'Twitters',
                style: mystyle(20),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 32,
              ),
              title: Text(
                'Search',
                style: mystyle(20),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 32,
              ),
              title: Text(
                'Profile',
                style: mystyle(20),
              )),
        ],
      ),
    );
  }
}
