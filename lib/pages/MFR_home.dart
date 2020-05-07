import 'package:ems_direct/pages/mfr_emergency_report.dart';
import 'package:ems_direct/services/auth.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/services/push_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/services/pending_emergency_alert_MFR.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ems_direct/pages/MapMFR.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import 'package:ems_direct/services/mfr_database.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';

GlobalKey<_MFRHomeState> mfrHomeGlobalKey = GlobalKey();

//This is the main homepage for any MFR login
class MFRHome extends StatefulWidget {
  //used to transfer data to the first created state
  bool _keepSignedIn = false;
  var _userData;
  Key key;

  MFRHome(bool keepSignedIn, var userData, Key passedkey) {
    _keepSignedIn = keepSignedIn;
    _userData = userData;
    key = passedkey;
  }

  @override
  _MFRHomeState createState() => _MFRHomeState(_keepSignedIn, _userData);
}

class _MFRHomeState extends State<MFRHome> with WidgetsBindingObserver {
  //keepMeSignedIn variable passed from login screen if successful
  bool _keepSignedIn = false;
  static Location _locationTracker = Location();
  StreamSubscription _locationSubscription;

  //user data doc
  var _userData;

  // constructor to set keepSignedIn and userData
  _MFRHomeState(bool keepSignedIn, var userData) {
    _keepSignedIn = keepSignedIn;
    _userData = userData;
    //print("--------------got ${_userData.data}");
  }

  //required variables
  static final databaseReference = Firestore.instance;
  DocumentReference mfrRef;
  Stream<QuerySnapshot> _documentStream;
  var isAvailable;
  var isOccupied = false;
  var gender;
  var locationOfEmergency;
  var patientContactNo;
  var patientRollNumber;
  var oldLatitude;
  var oldLongitude;

  //instance of auth service
  final AuthService _authMfr = AuthService();

  //cloud messaging for notifications
  final CloudMessagingService _notificationService = CloudMessagingService();

  //state management for keepsignedin ------------------------------------
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_keepSignedIn == false && state == AppLifecycleState.inactive) {
      _authMfr.logOut();
    }
  }

  //--------------------------------------------------------------------

  void _updateUserData(GeoPoint Newlocation) async {
    print(Newlocation.longitude);
    print(Newlocation.latitude);
    try {
      await databaseReference
          .collection("Mfr")
          .document(_userData['rollNo'])
          .updateData({'location': Newlocation});
    } catch (e) {
      throw (e);
    }
  }

  @override
  void initState() {
    super.initState();
    //State management for keepsignedin
    WidgetsBinding.instance.addObserver(this);
    //initializing stream to null as MFR will always be unavailable unless made available by himself
    _documentStream = null;
    _notificationService.getToken();
    _notificationService.configureFirebaseListeners();
    //setting initial data to be used in the widget below
    mfrRef = databaseReference.collection("Mfr").document(_userData['rollNo']);
    getInitialData(_userData['rollNo']);
  }

  //this is the function responsible for getting user's current location to be used in map
  void getCurrentLocation() async {
    try {
      while (true) {
        if (isAvailable) {
          var location = await _locationTracker.getLocation();

          var currLoc = LatLng(location.latitude, location.longitude);
          GeoPoint NewGeoPoint = GeoPoint(currLoc.latitude, currLoc.longitude);
          oldLatitude = currLoc.latitude;
          oldLongitude = currLoc.longitude;

          if (_locationSubscription != null) {
            _locationSubscription.cancel();
          }
          _updateUserData(NewGeoPoint);
          break;
        }
      }
      _locationSubscription =
          _locationTracker.onLocationChanged().listen((newLocation) {
        if (isAvailable) {
          GeoPoint NewGeoPoint =
              GeoPoint(newLocation.latitude, newLocation.longitude);
          var latitudeDifference = newLocation.latitude - oldLatitude;
          var longitudeDifference = newLocation.longitude - oldLongitude;
          var p = 0.017453292519943295;
          var distance = 0.5 -
              cos(latitudeDifference * p) / 2 +
              cos(newLocation.latitude * p) *
                  cos(oldLatitude * p) *
                  (1 - cos(longitudeDifference * p)) /
                  2;
          var meter = distance / 1000;
          if (meter > 5) {
            _updateUserData(NewGeoPoint);
          }

          oldLatitude = newLocation.latitude;
          oldLongitude = newLocation.longitude;
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  //this is the function which gets the initial data from the MFR's profile
  void getInitialData(var docId) async {
    try {
      getCurrentLocation();
      databaseReference.collection("Mfr").document(docId).get().then((onVal) {
        setState(() {
          isOccupied = onVal.data['isOccupied'];
          isAvailable = onVal.data['isActive'];
          gender = onVal.data['gender'];
          print('Initial data set done!');
        });
        
      }).catchError((onError) {
        print(onError.message);
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  //returning the document to determine state of the toggle button
  Future getInitialData2(var docId) async {
    try {
      return await databaseReference.collection("Mfr").document(docId).get();
    } catch (e) {
      print(e);
    }
  }

  //setting the stream value based on the availability status
  Stream<QuerySnapshot> setStreamValue(bool available, bool occupied) {
    if (available == null || occupied == null) {
      return null;
    }
    if (available && !occupied) {
      return databaseReference
          .collection('PendingEmergencies')
          .where('severity', whereIn: ['low', 'medium']).snapshots();
    } else {
      return null;
    }
  }

  //function call to set local occupied variable -> to be used by the pending_emergency_alert file
  void updateOccupied(bool val) {
    setState(() {
      isOccupied = val;
    });
  }

  //function call to set local emergency data variables -> to be used by the pending_emergency_alert file
  void updateEmergencyData(var location, var contact) {
    setState(() {
      locationOfEmergency = location;
      patientContactNo = contact;
    });
  }

  @override
  Widget build(BuildContext context) {
    //------- TESTING PURPOSES ------------------
    //print('Context rebuit');
    //print(isAvailable);
    //print(isOccupied);
    //-------------------------------------------

    //Getting screen dimensions to adjust widgets accordingly
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return Scaffold(
      backgroundColor: const Color(0xff27496d),
      //This contains the widgets seen in the drawer - also has navigation included
      drawer: Container(
        width: width *
            0.8, //making sure drawer extends to 80% of whatever screen it is
        child: Drawer(
          child: SafeArea(
            child: Column(
              //this column contains the drawer header, the option to view profile/emergency numbers/available MFRs list
              //also has the option to logout
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: height * 0.2,
                    child: Image(
                      image: AssetImage("assets/ems_logo.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                ConfigurableExpansionTile(
                  animatedWidgetFollowingHeader: const Icon(
                    Icons.expand_more,
                    color: const Color(0xFF707070),
                  ),
                  //headerExpanded: Flexible(child: Center(child: Text("A Header Changed"))),
                  header: Container(
                      color: Colors.transparent,
                      child: Center(
                          child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.account_circle,
                            color: const Color(0xff142850),
                            size: height / 20,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            _userData.data['name'].toString(),
                            style: TextStyle(
                              fontSize: 19,
                              fontFamily: 'HelveticaNeueLight',
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ))),
                  children: [
                    SizedBox(height: 10.0),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Roll number: ',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeueLight',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(width: 2.0),
                          Text(
                            _userData.data['rollNo'].toString(),
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Email: ',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeueLight',
                              fontWeight: FontWeight.bold,
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Contact: ',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeueLight',
                              fontWeight: FontWeight.bold,
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
                    SizedBox(height: 10.0),
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
                ListTile(
                  //the option to view emergency numbers - takes you to dummy page
                  title: Text(
                    'Avaiable MFRs',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'HelveticaNeueLight',
                      letterSpacing: 2.0,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/availableMfrs');
                  },
                ),
                Expanded(
                  //the option to logout (bottom center aligned)
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        //print('clicked');
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
                                      await _authMfr.logOut();
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
                                        letterSpacing: 3.0,
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
                      },
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
                              onPressed: null,
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
                ),
              ],
            ),
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
        child: Column(
          //everything is placed in the column
          children: <Widget>[
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
                  FutureBuilder(
                      future: getInitialData2(_userData.data['rollNo']),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('----- ERROR -> ${snapshot.error}');
                          } else {
                            return Transform.scale(
                                scale: 2.5,
                                child: isOccupied
                                    ? Switch(
                                        value: true,
                                        onChanged: null,
                                        inactiveThumbColor: Colors.green[50],
                                        inactiveTrackColor: Colors.green,
                                      )
                                    : Switch(
                                        value: isAvailable, //isAvailable,
                                        onChanged: (bool newVal) async {
                                          try {
                                            await mfrRef.updateData(
                                                {'isActive': newVal});
                                            setState(() {
                                              isAvailable = newVal;
                                              if (!isAvailable) {
                                                isOccupied = false;
                                              }
                                            });
                                            mfrAlertFunctionGlobalKey
                                                .currentState
                                                .updateStatus(
                                                    isAvailable, isOccupied);
                                          } catch (e) {
                                            print(e.toString());
                                          }
                                        },
                                        activeTrackColor: Colors.green,
                                        activeColor: Colors.green[50],
                                        inactiveThumbColor: Colors.white,
                                        inactiveTrackColor: Colors.red[200],
                                      ));
                          }
                        } else {
                          return Container(
                            child: SpinKitThreeBounce(
                              color: Colors.white,
                              size: 20,
                            ),
                          );
                        }
                      }),
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
                  child: InkWell(
                    onTap: () {
                      //print("tapped");
                      if (isOccupied) {
                        setState(() {
                          locationOfEmergency = mfrAlertFunctionGlobalKey
                              .currentState.locationOfEmergency;
                          patientContactNo = mfrAlertFunctionGlobalKey
                              .currentState.studentContactNo;
                          patientRollNumber = mfrAlertFunctionGlobalKey
                              .currentState.patientRollNumber;
                        });
                        if (locationOfEmergency != null &&
                            patientContactNo != null) {
                          print('location: $locationOfEmergency');
                          print('paient contact $patientContactNo');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapMFR(
                                      locationOfEmergency,
                                      patientContactNo,
                                      _userData.data['rollNo'].toString(),
                                      patientRollNumber)));
                        }
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        //if the isOccupied field is set to true, then enable map otherwise don't
                        isOccupied == null || !isOccupied
                            ? IconButton(
                                icon: Icon(
                                  Icons.location_on,
                                  color: Colors.grey[800],
                                  size: height / 9,
                                ),
                                onPressed: null,
                              )
                            : IconButton(
                                onPressed: null,
                                icon: Icon(
                                  Icons.location_on,
                                  color: Colors.red[800],
                                  size: height / 9,
                                ),
                              ),
                        Center(
                          child: Text(
                            'Map',
                            style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'HelveticaNeueLight',
                                letterSpacing: 2.0,
                                color:
                                    const Color(0xff142850) //Colors.cyan[800],
                                ),
                          ),
                        ),
                      ],
                    ),
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
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmergencyReportMfr()));
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            icon: Image(
                              image: AssetImage('assets/report.png'),
                              fit: BoxFit.fill,
                            ),
                            iconSize: height / 9,
                            onPressed: null,
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(0, 0, 0, height / 80),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
