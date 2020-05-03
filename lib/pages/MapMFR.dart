import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ems_direct/pages/MFR_home.dart';
import 'package:ems_direct/services/pending_emergency_alert_MFR.dart';

class MapMFR extends StatefulWidget {
  String _StudentContact = '';
  GeoPoint _locationOfEmergency;
  String _rollNo;
  String _patientRollNumber;
  MapMFR(GeoPoint locationOfEmergency, String patientContactNo, String rollNo,
      String patientRollNo)
      : super() {
    _StudentContact = patientContactNo;
    _locationOfEmergency = locationOfEmergency;
    _rollNo = rollNo;
    _patientRollNumber = patientRollNo;
  }

  @override
  MapState createState() => new MapState(
      _locationOfEmergency, _StudentContact, _rollNo, _patientRollNumber);
}

class MapState extends State<MapMFR> {
  GeoPoint _locationOfEmergency;
  String contactNumber = '';
  String _rollNo;
  String _patientRollNumber;
  bool _mapLoading = true;
  Map<MarkerId, Marker> emergencyMarker = <MarkerId, Marker>{};
  final databaseReference = Firestore.instance;

  MapState(
      GeoPoint location, String number, String rollNo, String patientRollNo) {
    _locationOfEmergency = location;
    contactNumber = number;
    _rollNo = rollNo;
    _patientRollNumber = patientRollNo;
  }

  void _updateUserData(GeoPoint Newlocation) async {
    await databaseReference
        .collection("Mfr")
        .document((await _rollNo).toString())
        .updateData({'location': Newlocation});
  }

  GoogleMapController _controller;
  static var Zoom = 11.0;
  static const LatLng _loc = const LatLng(45.531563, -122.677433);
  LatLng currLoc = _loc;
  var EmergencyLocationIcon;
  LatLng _lastMapPosition = _loc;
  MapType _currentMapType = MapType.normal;
  static Location _locationTracker = Location();

  Marker marker;
  StreamSubscription _locationSubscription;

  _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    var markerIdVal = emergencyMarker.length + 1;
    String mar = markerIdVal.toString();
    final MarkerId markerId = MarkerId(mar);
    EmergencyLocationIcon = BitmapDescriptor.fromAsset('assets/redcross.png');
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(
            _locationOfEmergency.latitude, _locationOfEmergency.longitude),
        infoWindow:
            InfoWindow(title: 'Emergency Location', snippet: _patientRollNumber),
        icon: EmergencyLocationIcon);
    setState(() {
      emergencyMarker[markerId] = marker;
    });
    getCurrentLocaion();
    this.setState(() => _mapLoading = false);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  static final CameraPosition initialisation = CameraPosition(
    target: LatLng(122, 72),
    zoom: Zoom,
  );

  void updateMarker(LocationData newLocation) {
    LatLng values = LatLng(newLocation.latitude, newLocation.longitude);
    var markerIdVal = emergencyMarker.length + 1;
    String mar = markerIdVal.toString();
    final MarkerId markerId = MarkerId(mar);
    final Marker marker = Marker(
      markerId: MarkerId("Your location"),
      infoWindow: InfoWindow(
        title: 'Your location',
      ),
      position: values,
      rotation: newLocation.heading,
      draggable: false,
      zIndex: 2,
      flat: false,
      anchor: Offset(0, 0),
    );
    setState(() {
      emergencyMarker[markerId] = marker;
    });
  }

  void zoomIn() async {
    _controller.animateCamera(
      CameraUpdate.zoomIn(),
    );
  }

  void zoomOut() async {
    _controller.animateCamera(
      CameraUpdate.zoomOut(),
    );
  }

  void getCurrentLocaion() async {
    try {
      var location = await _locationTracker.getLocation();

      updateMarker(location);
      currLoc = LatLng(location.latitude, location.longitude);
      _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192,
                  target: LatLng(currLoc.latitude, currLoc.longitude),
                  tilt: 0,
                  zoom: Zoom)));
      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged().listen((newLocation) {
        if (_controller != null) {
//          currLoc = LatLng(newLocation.latitude, newLocation.longitude);
//
//          _controller.animateCamera(CameraUpdate.newCameraPosition(
//              new CameraPosition(
//                  bearing: 192,
//                  target: LatLng(newLocation.latitude, newLocation.longitude),
//                  tilt: 0,
//                  zoom: Zoom)));
          GeoPoint NewGeoPoint =
              GeoPoint(newLocation.latitude, newLocation.longitude);
          _updateUserData(NewGeoPoint);
          updateMarker(newLocation);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }




  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff142850),
          title: Text(
            'Map',
            style: TextStyle(
              fontFamily: 'HelveticaNeueLight',
              letterSpacing: 2.0,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: initialisation,
              mapType: _currentMapType,
              markers: Set<Marker>.of(emergencyMarker.values),
              onCameraMove: _onCameraMove,
            ),
            (_mapLoading)
                ? Container(
                    height: height,
                    width: width,
                    color: Colors.grey[100],
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(),
          Container(
              margin: const EdgeInsets.fromLTRB(45, 10, 10, 10),
          height: 38,
          width: 240,
          child: Card(
            elevation: 1,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Patient Contact: ' + contactNumber,
                    style: TextStyle(
                      fontFamily: 'HelveticaNeueBold',
                      letterSpacing: 2.0,
                      fontSize: 0.012 * (height + width),
                      color: const Color(0xff142850),
                    ),
                  )

                ],
              ),
            ),
          )
        ),
//            Padding(
//                padding: EdgeInsets.fromLTRB(
//                    width * 0.14, height * 0.034, width * 0.1, 10.0),
//                child: Text(
//                  'Patient Contact: ' + contactNumber,
//                  style: TextStyle(
//                    fontFamily: 'HelveticaNeueBold',
//                    letterSpacing: 2.0,
//                    fontSize: 0.012 * (height + width),
//                    color: const Color(0xff142850),
//                  ),
//                )),
            Padding(
                padding: EdgeInsets.fromLTRB(
                    width * 0.23, height * 0.75, width * 0.16, 10.0),
                child: SizedBox(
                    width: (width + height) * 0.18,
                    height: (width + height) * 0.04,
                    child: RaisedButton(
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
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        try {
                                          await Firestore.instance
                                              .collection('OngoingEmergencies')
                                              .document(_patientRollNumber)
                                              .delete();
                                          await Firestore.instance
                                              .collection('Mfr')
                                              .document(_rollNo)
                                              .updateData(
                                                  {'isOccupied': false});
                                          mfrHomeGlobalKey.currentState
                                              .updateOccupied(false);
                                          mfrAlertFunctionGlobalKey.currentState
                                              .updateOccupiedLocal(false);
                                        } catch (e) {
                                          print(e);
                                        }
//                                        todo: occupied status change
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
                        },
                        textColor: Colors.cyan[500],
                        color: const Color(0xffee0000),
                        // todo: update occupied status
                        child: Text(
                          'End Emergency',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: (width + height) * 0.012,
                            letterSpacing: 3.0,
                            fontFamily: 'HelveticaNeueBold',
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )))),
          ],
        ),
        floatingActionButton: Column(children: <Widget>[
          SizedBox(height: height * 0.16),
          FloatingActionButton(
              heroTag: "btn1",
              child: Icon(Icons.map),
              onPressed: () {
                _onMapTypeButtonPressed();
              },
              backgroundColor: const Color(0xff47719e)),
          SizedBox(height: height / 3),
          FloatingActionButton(
              heroTag: "btn2",
              child: Icon(Icons.add),
              onPressed: () {
                zoomIn();
              },
              backgroundColor: const Color(0xff47719e)),
          SizedBox(height: 10),
          FloatingActionButton(
              heroTag: "btn3",
              child: Icon(Icons.remove),
              onPressed: () {
                zoomOut();
              },
              backgroundColor: const Color(0xff47719e)),
          SizedBox(height: 10),
          FloatingActionButton(
              heroTag: "btn4",
              child: Icon(Icons.location_searching),
              onPressed: () {
                if (_controller != null) {

                  _controller.animateCamera(CameraUpdate.newCameraPosition(
                      new CameraPosition(
                        bearing: 192,
                        target: LatLng(_locationOfEmergency.latitude, _locationOfEmergency.longitude),
                        tilt: 0,
                        zoom: 20,
                      )));

                }
              },
              backgroundColor: const Color(0xff47719e)),
        ]),
      ),
    );
  }
}
