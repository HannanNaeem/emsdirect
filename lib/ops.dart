import 'package:flutter/material.dart';
import 'package:ems_direct/records.dart';

class Ops extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<Ops> {

  int _selectedPage = 2;
  final _pageOptions = [
    Center(child: Text('Log')),
    Center(child: Text('Notifications')),
    Center(child: Text('Map')),
    Records(),
  ];
  List<String> _headerNames = ['Emergency Log', 'Notifications', 'Map', 'Records'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff3596b5),
        title: Text(
          _headerNames[_selectedPage],
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'HelveticaNeue',
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
        backgroundColor: const Color(0xff3596b5),
        selectedItemColor: Colors.white,
        selectedFontSize: 15,
        unselectedItemColor: const Color(0xff73cde8),
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