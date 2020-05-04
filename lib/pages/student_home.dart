import 'package:ems_direct/services/auth.dart';
import 'package:ems_direct/services/push_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:ems_direct/pages/live_status.dart';
import 'package:ems_direct/pages/emergency_numbers.dart';

class StudentHome extends StatefulWidget {

  var _userData;
  StudentHome(bool keepSignedIn, var userData){
    _keepSignedIn = keepSignedIn;
    _userData = userData;
  }

  bool _keepSignedIn = false;
  @override
  _StudentHomeState createState() => _StudentHomeState(_keepSignedIn,_userData);
}


class _StudentHomeState extends State<StudentHome> with WidgetsBindingObserver {

  //keepMeSignedIn vairable passed from login screen if successful
  bool _keepSignedIn = false;
  //document for userData
  var _userData;

  // constructor to set keepSignedIn
  _StudentHomeState(bool keepSignedIn, var userData){
    _keepSignedIn = keepSignedIn;
    _userData = userData;

    print("-----------------------got ${_userData.data}");
  }
  var uid;
  List<bool> _selections =[true, false, false,false];
  List<bool> _selections2 = [true,false,false];
  List<String> _genderPreferences = ['NA', 'M', 'F'];
  List<String> _severityLevels = ['low', 'medium', 'high', 'critical'];
  int _gender = 0;
  int _severityLevel = 0;
  bool _emergency = false;
  Position _currentLocation; //location from geolocator
  GeoPoint _geoLocation; //converted location into a geopoint
  /////////////////////////////////////////////////////////////////

  //function to get current location of the student to update to the database
  _getCurrentLocation() async{
    _currentLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _geoLocation = GeoPoint(_currentLocation.latitude,_currentLocation.longitude);
  }


  //instance of auth service
  final AuthService _authStudent = AuthService();

  //! ----- Cloudmessaging service for notifications ----- !//
  final CloudMessagingService _notificationService = CloudMessagingService();


  //State management for keepsignedin ----------------------------------
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getCurrentLocation();
    uid = _authStudent.currentUser();

    _notificationService.getToken();
    _notificationService.configureFirebaseListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(_keepSignedIn == false && state == AppLifecycleState.inactive){
      _authStudent.logOut();
    }
  }
  // ---------------------------------------------------------------------------------

  //an object made to work with firestore
  final databaseReference = Firestore.instance;

  /////////////////////////// FUNCTIONS ///////////////////////////
  void _getData() {
    databaseReference
        .collection('OngoingEmergencies')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach(((f) => print('${f.data}')));
    });
  }

  //function to generate doc in the pending emergency collection for the current user
  void _createPendingEmergencyDocument(GeoPoint location, String genderPref,
      String severityLevel, String rollNumber, String contact, DateTime time) async {
    await databaseReference
        .collection("PendingEmergencies")
        .document( _userData.data['rollNo'].toString())
        .setData({
      'patientContactNo' : contact,
      'declinedBy' : [],
      'location': location,
      'genderPreference': genderPref,
      "patientRollNo": rollNumber,
      'severity': severityLevel,
      'declines': 0,
      'reportingTime': time
    });
  }

  //function to update the user data collection of the current user to show that emergency has started
  void _updateUserData() async{
    await databaseReference
        .collection("UserData")
        .document((await uid).toString())
        .updateData({
      'loggedInAs': 'emergency'
    });
  }

  //function to set user collection to not emergency
  void _setNotEmergency() async{
    await databaseReference
        .collection("UserData")
        .document((await uid).toString())
        .updateData({
      'loggedInAs': ''
    });
  }
  /////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    _setNotEmergency();

    return Scaffold(
        backgroundColor: const Color(0xff27496d),
        drawer: Container(
          width: width * 0.8, //drawer covers 80% of the screen
          child: Drawer(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EmergencyNumbers()),
                    );
                  },
                ),
                Expanded(
                  //the option to logout (bottom center aligned)
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding:
                          EdgeInsets.fromLTRB(width * 0.8 * 0.24, 0, 0, 10.0),
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
                                            //! signout here
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
        ),
        appBar: AppBar(
          title: Text(
            'Home',
            style: TextStyle(
              fontSize: 24.0,
              fontFamily: 'HelveticaNeueLight',
              letterSpacing: 2.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xff142850),
        ),
        body: Center(
          child: Container(
            constraints: BoxConstraints.expand(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: height / 50),
                Text(
                  'Severity Level',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'HelveticaNeueLight',
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: height / 76),
                Card(
                  color: const Color(0xff00a8cc),
                  child: ToggleButtons(
                    constraints: BoxConstraints(
                        minWidth: width / 5, minHeight: height / 11),
                    children: <Widget>[
                      Text(
                        "Low",
                        style: TextStyle(
                          fontFamily: 'HelveticaNeueLight',
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                        "Medium",
                        style: TextStyle(
                          fontFamily: 'HelveticaNeueLight',
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                        "High",
                        style: TextStyle(
                          fontFamily: 'HelveticaNeueLight',
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                        "Critical",
                        style: TextStyle(
                          fontFamily: 'HelveticaNeueLight',
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                    color: Colors.white,
                    selectedColor: Colors.white,
                    fillColor: Colors.redAccent,
                    borderColor: Colors.white,
                    selectedBorderColor: Colors.white,
                    isSelected: _selections,
                    onPressed: (int index) {
                      setState(() {
                        for (int buttonIndex = 0;
                            buttonIndex < _selections.length;
                            buttonIndex++) {
                          if (buttonIndex == index) {
                            _selections[buttonIndex] = true;
                          } else {
                            _selections[buttonIndex] = false;
                          }
                          _severityLevel = index;
                        }
                        print(_severityLevel);
                      });
                    },
                  ),
                ),
                SizedBox(height: height / 30),
                Text(
                  'Prefered MFR Gender',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                    letterSpacing: 2.0,
                    fontFamily: 'HelveticaNeueLight',
                  ),
                ),
                SizedBox(height: height / 76),
                Card(
                  color: const Color(0xff00a8cc),
                  child: ToggleButtons(
                    constraints: BoxConstraints(
                        minWidth: width / 5.5, minHeight: height / 11),
                    children: <Widget>[
                      Text(
                        "N/A",
                        style: TextStyle(
                          fontFamily: 'HelveticaNeueLight',
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                        "Male",
                        style: TextStyle(
                          fontFamily: 'HelveticaNeueLight',
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                        "Female",
                        style: TextStyle(
                          fontFamily: 'HelveticaNeueLight',
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                    color: Colors.white,
                    selectedColor: Colors.white,
                    fillColor: Colors.redAccent,
                    borderColor: Colors.white,
                    selectedBorderColor: Colors.white,
                    isSelected: _selections2,
                    onPressed: (int index) {
                      setState(() {
                        print(index);
                        for (int buttonIndex = 0;
                            buttonIndex < _selections2.length;
                            buttonIndex++) {
                          if (buttonIndex == index) {
                            _selections2[buttonIndex] = true;
                          } else {
                            _selections2[buttonIndex] = false;
                          }
                          _gender = index;
                          print(_gender);
                        }
                      });
                    },
                  ),
                ),
                SizedBox(height: height / 35),
                RawMaterialButton(
                    onPressed: () {
                      setState(() {
                        _emergency = true;
                      });
                    },
                    //SOS function implemented here
                    //A 'PendingEmergencies' document is created in the database with relevant attributes set
                    //Student is taken to the live updates screen for live feedback
                    onLongPress: () {
                      _createPendingEmergencyDocument(_geoLocation, _genderPreferences[_gender], _severityLevels[_severityLevel],  _userData.data['rollNo'].toString(),  _userData.data['contact'].toString(), DateTime.now());
                      _updateUserData();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LiveStatus(_keepSignedIn,_userData)
                          )
                      );
                      print("emergency initiated");
                    },
                    fillColor: Colors.red[400],
                    elevation: 10.0,
                    constraints: BoxConstraints(
                        minHeight: height / 2.7, minWidth: height / 2.7),
                    child: Text(
                      'SOS',
                      style: TextStyle(
                        fontSize: 70.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'HelveticaNeue',
                        letterSpacing: 2.0,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(height / 2.7),
                    )),
                SizedBox(height: height / 45),
                Text(
                  'TAP AND HOLD',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.red[400],
                    fontFamily: 'HelveticaNeueLight',
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: height / 120),
                Text(
                  'INITIATE EMERGENCY',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.red[400],
                    fontFamily: 'HelveticaNeueLight',
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
