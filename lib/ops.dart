import 'package:ems_direct/services/emergency_alert_ops.dart';
import 'package:ems_direct/services/ops_map_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/records.dart';
import 'package:ems_direct/map.dart';
import 'package:ems_direct/notifications.dart';
import 'package:ems_direct/emergency_log.dart';
import 'package:ems_direct/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/services/ops_database.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
 
// ---------------------- GLOBAL KEY TO SET OPS HOMEPAGE --------------//
GlobalKey<_OpsHomeState> opsGlobalKey = GlobalKey();


class OpsHome extends StatefulWidget {

  //used to transfer data to the first created state
  bool _keepSignedIn = false;
  var _userData;
  Key key;

  OpsHome(bool keepSignedIn, var userData, Key passedKey) {
    _keepSignedIn = keepSignedIn;
    _userData = userData;
    key = passedKey;
  }

  @override
  _OpsHomeState createState() => _OpsHomeState(_keepSignedIn,_userData);
}

class _OpsHomeState extends State<OpsHome> with WidgetsBindingObserver {

  //Authentication service 
  final AuthService _authOps = AuthService();

  //keepMeSignedIn variable passed from login screen if successful
  bool _keepSignedIn = false;

  //user data doc
  var _userData;

  // constructor to set keepSignedIn and userData
  _OpsHomeState(bool keepSignedIn, var userData) {
    _keepSignedIn = keepSignedIn;
    _userData = userData;

  }


  //State management for keepsignedin ----------------------------------
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(_keepSignedIn == false && state == AppLifecycleState.inactive){
      _authOps.logOut();
    }
  }
  // ---------------------------------------------------------------------------------


  int _selectedPage = 2;

  void setPage(int moveTo){
    setState(() {
      _selectedPage = moveTo;
    });
  }


  final _pageOptions = [
    EmergencyLog(),
    Notifications(),
    OpsMapWrapper(),
    Records(),
  ];
  List<String> _headerNames = [
    'Emergency Log',
    'Notifications',
    'Map',
    'Records'
  ];



  // ------------------------------------------------------------

  // ------------- Notification handler ------------------------//
  
 
  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    //final ignoredEmergencies = Provider.of<QuerySnapshot>(context);

    

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
                _userData.data['name'].toString(),
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
                        _userData.data['rollNo'].toString(),
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
                        _userData.data['email'].toString(),
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
                        _userData.data['contact'].toString(),
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

                                        //signout here
                                        await _authOps.logOut();
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


      body: Stack(
        children: <Widget>[
          _pageOptions[_selectedPage],
        ],
      ),

      
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
        unselectedItemColor: const Color(0xff47719e),

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
