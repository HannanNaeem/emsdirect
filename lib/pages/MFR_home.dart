import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/pages/emergency_numbers.dart';
import 'package:ems_direct/pages/available_MFRs.dart';
import 'package:ems_direct/services/auth.dart';

class PendingEmergency {
  GeoPoint location;
  String genderPreference;
  String severityLevel;
  int rollNumber;
}

class AlertFunction extends StatefulWidget {
  var availability;
  var length;
  var render;

  AlertFunction({this.availability, this.length, this.render});
  @override
  _AlertFunctionState createState() => _AlertFunctionState();
}

class _AlertFunctionState extends State<AlertFunction> {
  void showAlert(bool available, int num, bool render) {
    num = 1;
    if (available == true && num > 0 && render) {
      print(render);
      print('show dialog');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Are you sure?",
            style: TextStyle(
              fontFamily: 'HelveticaNeueLight',
              letterSpacing: 2.0,
              fontSize: 20,
              //color: Colors.grey[600],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'YES',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3.0,
                  fontSize: 20,
                  color: const Color(0xff1a832a),
                ),
              ),
              onPressed: () {
                print('yes');
                //dispose();
              },
            ),
            FlatButton(
              child: Text(
                'NO',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.5,
                  fontSize: 20,
                  color: const Color(0xffee0000),
                ),
              ),
              onPressed: () {
                print('no');
                Navigator.of(context).pop();
                //dispose();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    print('widget disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('IN THIS FUNCTION');
    //Future.delayed(Duration.zero, () => showAlert());
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => showAlert(widget.availability, widget.length, widget.render));
    return Container(key: UniqueKey());
  }
}

//This is the main homepage for any MFR login
class MFRHome extends StatefulWidget {
  @override
  _MFRHomeState createState() => _MFRHomeState();
}

class _MFRHomeState extends State<MFRHome> {
  //Tells whether toggle switch is to be on or off
  bool isAvailable = false;
  final databaseReference = Firestore.instance;
  //StreamController<QuerySnapshot> stream = new StreamController<QuerySnapshot>();
  //StreamController<int> stream = StreamController<int>();
  // StreamController stream = StreamController();
  Stream<QuerySnapshot> _documentStream;
  var length = 0;
  DocumentSnapshot qs = null;
  bool shouldRender = false;
  String _rollNumber = '21100118';
  String _contact = '03362356254';
  String _email = '21100118@lums.edu.pk';
  //instance of auth service
  final AuthService _auth = AuthService();
  final AuthService _authStudent = AuthService();

  /////////////////////////// FUNCTIONS ///////////////////////////
  void _getData() {
    databaseReference
        .collection('OngoingEmergencies')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach(((f) => print('${f.data}')));
    });
  }
  /////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    _documentStream = null;
    //_documentStream = databaseReference.collection('PendingEmergencies').where('severity', isEqualTo: 'low').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    print('Context rebuit');

    //Getting screen dimensions to adjust widgets accordingly
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    var pendingEmergency;

    //Defines the whole layout of the homepage
    return Scaffold(
      backgroundColor: const Color(0xff27496d),
      //This contains the widgets seen in the drawer - also has navigation included
      drawer: Container(
        width: width *
            0.8, //making sure drawer extends to 80% of whatever screen it is
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
      ),
      //This is the appBar which has the main heading and the drawer option
      appBar: AppBar(
        backgroundColor: const Color(0xff142850),
        title: Text(
          'Home',
          style: TextStyle(
            fontFamily: 'HelveticaNeueLight',
            letterSpacing: 2.0,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      //This is where the toggle option and the two cards (Map and Report Emergency) reside
      body: Center(
          child: StreamBuilder<QuerySnapshot>(
              stream: null, //_documentStream,
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  length = snapshot.data.documents.length;
                  if (qs == null) {
                    shouldRender = true;
                    qs = snapshot.data.documents[0];
                  } else if (qs == snapshot.data.documents[0]) {
                    shouldRender = false;
                  } else {
                    shouldRender = true;
                  }
//                  for (int i = 0; i < length; i++) {
//                    print(snapshot.data.documents[i].data);
//                  }
                }
                return Column(
                  //everything is placed in the column
                  children: <Widget>[
                    AlertFunction(
                        availability: isAvailable,
                        length: length,
                        render:
                            shouldRender), //showAlert(isAvailable, length), //AlertFunction(),
                    Flexible(
                      flex: 3,
                      child: Container(
                        height: height / 5,
                        width: width / 1.5,
                        child: Row(children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Available',
                              style: TextStyle(
                                  fontFamily: 'HelveticaNeueLight',
                                  letterSpacing: 2.0,
                                  fontSize: 24,
                                  color: Colors.white //const Color(0xff142850),
                                  ),
                            ),
                          ),
                          Transform.scale(
                            scale: 2.5,
                            child: Switch(
                              value: isAvailable,
                              onChanged: (bool newVal) {
                                setState(() {
                                  isAvailable = newVal;
                                  if (isAvailable == true) {
                                    _documentStream = databaseReference
                                        .collection('PendingEmergencies')
                                        .where('severity', isEqualTo: 'low')
                                        .snapshots();
                                  } else {
                                    _documentStream = null;
                                  }
                                });
                              },
                              activeTrackColor: Colors.green,
                              activeColor: Colors.green[50],
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.red[200],
                            ),
                          ),
                        ]),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: SizedBox(
                        height: height / 4,
                        width: width / 1.5,
                        child: Card(
                          elevation: 7,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.location_on,
                                  color: Colors.red[400],
                                  size: height / 9,
                                ),
                                onPressed: () {
                                  print('Clicked');
                                },
                              ),
                              Center(
                                child: Text(
                                  'Map',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontFamily: 'HelveticaNeueLight',
                                      letterSpacing: 2.0,
                                      color: const Color(
                                          0xff142850) //Colors.cyan[800],
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 16,
                    ),
                    Flexible(
                      flex: 4,
                      child: SizedBox(
                        height: height / 4,
                        width: width / 1.5,
                        child: Card(
                          elevation: 7,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                IconButton(
                                  icon: Image(
                                    image: AssetImage('assets/report.png'),
                                    fit: BoxFit.fill,
                                  ),
                                  iconSize: height / 9,
                                  onPressed: () {
                                    print('Clicked');
                                  },
                                ),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0, 0, 0, height / 80),
                                    child: Text(
                                      'Report Emergency',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontFamily: 'HelveticaNeueLight',
                                        letterSpacing: 2.0,
                                        color: const Color(0xff142850),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    )
                  ],
                );
              })),
    );
  }
}
