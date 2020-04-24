import 'package:flutter/material.dart';
import 'package:ems_direct/records.dart';
import 'package:ems_direct/map.dart';
import 'package:ems_direct/notifications.dart';
import 'package:ems_direct/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  String _rollNumber = '21100118';
  String _contact = '03362356254';
  String _email = '21100118@lums.edu.pk';
  //instance of auth service
  final AuthService _auth = AuthService();
  final AuthService _authStudent = AuthService();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

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
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          //this column contains the drawer header, the option to view profile/emergency numbers/available MFRs list
          //also has the option to logout
          children: <Widget>[
            DrawerHeader(
              //only the ems logo
              child: Container(
                child: Image.asset("assets/ems_logo.png"),
              ),
            ),
            ExpansionTile(
              leading: Icon(
                Icons.account_circle,
                color: const Color(0xff142850),
              ),
              title: Text(
                'Harum Naseem',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'HelveticaNeueLight',
                  letterSpacing: 1.0,
                ),
              ),
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(maxWidth: width * 0.75),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Rollnumber:',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'HelveticaNeueLight',
                          letterSpacing: 1.0,
                        ),
                      ),
                      SizedBox(width: 2.0),
                      Text(
                        '$_rollNumber',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'HelveticaNeueLiight',
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  constraints: BoxConstraints(maxWidth: width * 0.75),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Email:',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'HelveticaNeueLight',
                          letterSpacing: 1.0,
                        ),
                      ),
                      SizedBox(width: 2.0),
                      Text(
                        _email,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'HelveticaNeueLight',
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  constraints: BoxConstraints(maxWidth: width * 0.75),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Contact:',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'HelveticaNeueLight',
                          letterSpacing: 1.0,
                        ),
                      ),
                      SizedBox(width: 1.0),
                      Text(
                        '$_contact',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'HelveticaNeueLight',
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ListTile(
              //the option to view emergency numbers - takes you to dummy page
              title: Text(
                'Emergency Numbers',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'HelveticaNeueLight',
                  letterSpacing: 2.0,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/emergencyNumbers');
                //print('Emergency numbers');
              },
            ),
            Expanded(
              //the option to logout (bottom center aligned)
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(width * 0.8 * 0.24, 0, 0, 10.0),
                  child: Row(
                    //has the icon and text
                    children: <Widget>[
                      IconButton(
                        icon: Image(
                          image: AssetImage('assets/logout.png'),
                          fit: BoxFit.fill,
                          color: const Color(0xff142850),
                        ),
                        color: const Color(0xff142850),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "Are you sure?",
                                    style: TextStyle(
                                      fontFamily: 'HelveticaNeueLight',
                                      letterSpacing: 2.0,
                                      fontSize: 20,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        'YES',
                                        style: TextStyle(
                                          fontFamily: 'HelveticaNeueLight',
                                          letterSpacing: 3.0,
                                          fontSize: 20,
                                          color: const Color(0xff1a832a),
                                        ),
                                      ),
                                      onPressed: () async {
                                        //navigation to login screen
                                        //todo signout here
                                        await _auth.logOut();
                                        //todo signout here
                                        await _authStudent.logOut();
                                        Navigator.of(context).pop();
                                        Navigator.pushReplacementNamed(
                                            context, '/select_login');
                                      },
                                    ),
                                    FlatButton(
                                      child: Text(
                                        'NO',
                                        style: TextStyle(
                                          fontFamily: 'HelveticaNeueLight',
                                          letterSpacing: 2.5,
                                          fontSize: 20,
                                          color: const Color(0xffee0000),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                          //print('logout');
                        },
                      ),
                      Text(
                        'LOGOUT',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'HelveticaNeueBold',
                          color: const Color(0xff142850),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
