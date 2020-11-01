import 'package:flutter/material.dart';
import './room_page.dart';
//import './Login.dart';
import './settings_page.dart';

class HomeScreen extends StatefulWidget {
  /*
  String token;
  HomeScreen({Key key, @required this.token}) : super(key: key); */

  @override
  State<StatefulWidget> createState() => HomeScreenState(/*token*/);
}

class HomeScreenState extends State<HomeScreen> {
  /*
  String token;
  HomeScreenState(this.token);*/

  int _selectedTab = 0;
  final _pageOptions = [
    RoomPage(),
    //LoginPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.orange,
          primaryTextTheme: TextTheme(
            headline6: TextStyle(color: Colors.white),
          )),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Alarm System'),
        ),
        body: _pageOptions[_selectedTab],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (int index) {
            setState(() {
              _selectedTab = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
