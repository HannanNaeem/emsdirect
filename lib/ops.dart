import 'package:flutter/material.dart';
import 'package:ems_direct/records.dart';
import 'package:ems_direct/map.dart';
import 'package:ems_direct/notifications.dart';

class Ops extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<Ops> {
  int _selectedPage = 2;
  final _pageOptions = [
    Center(child: Text('Log')),
    Notifications(),
    OpsMap(),
    Records(),
  ];
  List<String> _headerNames = [
    'Emergency Log',
    'Notifications',
    'Map',
    'Records'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff142850),
        title: Text(
          _headerNames[_selectedPage],
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'HelveticaNeueLight',
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(),
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff142850),
        selectedItemColor: Colors.white,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        unselectedItemColor: const Color(0xff27496d),
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_drive_file),
            title: Text(
              'Log',
              style: TextStyle(
                fontFamily: 'HelveticaNeueLight',
              )
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text(
              'Notifications',
              style: TextStyle(
                fontFamily: 'HelveticaNeueLight',
              )
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            title: Text(
              'Map',
              style: TextStyle(
                fontFamily: 'HelveticaNeueLight',
              )
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            title: Text(
              'Records',
              style: TextStyle(
                fontFamily: 'HelveticaNeueLight',
              )
            ),
          ),
        ],
      ),
    );
  }
}
