import 'package:flutter/material.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedPage = 2;
  final _pageOptions = [
    Center(child: Text('Log')),
    Center(child: Text('Notifications')),
    Center(child: Text('Map')),
    Center(child: Text('Records')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Records'),
        centerTitle: true,
        backgroundColor: Colors.cyan[800],
        elevation: 0.0,
      ),
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.cyan[800],
        selectedItemColor: Colors.white,
        selectedFontSize: 15,
        unselectedItemColor: Colors.cyan[300],
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_drive_file),
            title: Text('Log'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text('Notifications'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            title: Text('Map'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            title: Text('Records'),
          ),
        ],
      ),
    );
  }
}