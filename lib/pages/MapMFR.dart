import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ems_direct/pages/MFR_home.dart';
import 'package:ems_direct/services/pending_emergency_alert_MFR.dart';

// Displays the map to the MFR with their current location as well as the emergency location of the emergency they have been assigned to.
// MFR can only see this screen if they are on an emergency.

class MapMFR extends StatefulWidget {
  // Patient information variables
  String patientContact;
  String rollNumber;
  String patientRollNumber;

  // Emergency location point
  GeoPoint locationOfEmergency;

  // Constructor
  MapMFR(GeoPoint location, String contactNo, String rollNo,
      String patientRollNo)
      : super() {
    patientContact = contactNo;
    locationOfEmergency = location;
    rollNumber = rollNo;
    patientRollNumber = patientRollNo;
  }

  @override
  MapState createState() => new MapState();
}

class MapState extends State<MapMFR> {
  // This is used to determine if the map has loaded or not - to display Circular Progress Indicator while the map is being loaded
  bool mapLoading = true;

  // The map view is controlled using this controller
  GoogleMapController controller;

  // Used to keep track of the current location
  static LatLng currLoc = const LatLng(45.531563, -122.677433);

  // Used to keep track of the last map position
  LatLng lastMapPosition = currLoc;

  // Used to keep track of the map type - normal or satellite.
  // Initially its been set to normal
  MapType currentMapType = MapType.normal;

  // Used to track the location of the MFR
  static Location locationTracker = Location();

  // Used to listen on a stream using stream.list
  StreamSubscription locationSubscription;

  // Stores all markers for the map
  Map<MarkerId, Marker> emergencyMarker = <MarkerId, Marker>{};

  // initial position of the map camera
  static final CameraPosition initialPosition = CameraPosition(
    target: LatLng(45.531563, -122.677433),
    zoom: 8.0,
  );

  // Called when the map has been created
  onMapCreated(GoogleMapController _controller) {
    controller = _controller;
    // determining marker id to add to set
    var markerIdVal = emergencyMarker.length + 1;
    String mar = markerIdVal.toString();
    final MarkerId markerId = MarkerId(mar);

    // making an asset image the marker icon
    var emergencyLocationIcon = BitmapDescriptor.fromAsset('assets/redcross.png');

    // creating a marker
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(
            widget.locationOfEmergency.latitude, widget.locationOfEmergency.longitude),
        infoWindow: InfoWindow(
            title: 'Emergency Location', snippet: widget.patientRollNumber),
        icon: emergencyLocationIcon);

    // setting the marker
    setState(() {
      emergencyMarker[markerId] = marker;
    });


   // todo: uncomment
    //getCurrentLocation();

    // making mapLoading false so that the map can be displayed now
    this.setState(() => mapLoading = false);

  }

  // Called when camera is moved around so that the last map position can be updated
  onCameraMove(CameraPosition position) {
    lastMapPosition = position.target;
  }

  // Called when the user wishes to change the map type
  onMapTypeButtonPressed() {
    // Setting the map type to the opposite to what it was previously
    setState(() {
      currentMapType = currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  // Updating the MFR marker according to the newLocation
  void updateMarker(LocationData newLocation) {
    // converting LocationData to LatLng
    LatLng values = LatLng(newLocation.latitude, newLocation.longitude);

    // determining marker id
    var markerIdVal = emergencyMarker.length + 1;
    String mar = markerIdVal.toString();
    final MarkerId markerId = MarkerId(mar);

    // creating marker
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

    // setting marker
    setState(() {
      emergencyMarker[markerId] = marker;
    });
  }

  // Called when the user wishes to zoom into the map
  void zoomIn() async {
    // changing camera position
    controller.animateCamera(
      CameraUpdate.zoomIn(),
    );
  }

  // Called when the user wishes to zoom out of the map
  void zoomOut() async {
    // changing camera position
    controller.animateCamera(
      CameraUpdate.zoomOut(),
    );
  }


  // Used to determine/track the current location of the MFR
  void getCurrentLocation() async {
    try {
      //getting the current location
      var location = await locationTracker.getLocation();

      // updating the marker on the map
      updateMarker(location);

      // updating the current location
      currLoc = LatLng(location.latitude, location.longitude);

      // updating the camera position to where the MFR is currently
      controller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: 192,
              target: LatLng(currLoc.latitude, currLoc.longitude),
              tilt: 0,
              zoom: 8.0)));

      // cancelling location subscription
      if (locationSubscription != null) {
        locationSubscription.cancel();
      }

      // constantly listening to see if location of MFR has updated
      locationSubscription =
          locationTracker.onLocationChanged().listen((newLocation) {
            // updating marker position on map
            if (controller != null) {
              updateMarker(newLocation);
            }
      });
    } on PlatformException catch (e) {
      // exception thrown if the location permission is denied.
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
      throw(e);
    }
  }


  @override
  // Called when this object is removed from the tree permanently
  void dispose() {
    // cancelling location subscription so that listening is stopped
    if (locationSubscription != null) {
      locationSubscription.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Used to make screen responsive.
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
            // Google map widget is used to create map
            GoogleMap(
              onMapCreated: onMapCreated,
              initialCameraPosition: initialPosition,
              mapType: currentMapType,
              markers: Set<Marker>.of(emergencyMarker.values),
              onCameraMove: onCameraMove,
            ),
            // while map is loading, a circular progress indicator is shown.
            (mapLoading)
                ? Container(
                    height: height,
                    width: width,
                    color: Colors.grey[100],
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(),
            // Showing patient contact on top of the map
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
                          'Patient Contact: ' + widget.patientContact,
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
                )),
            // End emergency button and its navigation
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
                                        // When the MFR ends the emergency


                                        try {
                                          // deleting emergency from ongoing emergencies collection in the database
                                          await Firestore.instance
                                              .collection('OngoingEmergencies')
                                              .document(widget.patientRollNumber)
                                              .delete();

                                          // changing mfr's isOccupied status to false in the database
                                          await Firestore.instance
                                              .collection('Mfr')
                                              .document(widget.rollNumber)
                                              .updateData(
                                                  {'isOccupied': false});

                                          // setting local occupied variables to false
                                          mfrHomeGlobalKey.currentState
                                              .updateOccupied(false);
                                          mfrAlertFunctionGlobalKey.currentState
                                              .updateOccupiedLocal(false);
                                        } catch (e) {
                                          throw(e);
                                        }

                                        // Navigating back to MFR home screen
                                       Navigator.of(context).pop();
                                        Navigator.of(context).pop();
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
                                        // User doesn't wish to end emergency (for now)
                                        // Navigating back to map screen
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
        // User can change the map type by clicking on this button
        floatingActionButton: Column(children: <Widget>[
          SizedBox(height: height * 0.16),
          FloatingActionButton(
              heroTag: "btn1",
              child: Icon(Icons.map),
              onPressed: () {
                onMapTypeButtonPressed();
              },
              backgroundColor: const Color(0xff47719e)),
          SizedBox(height: height / 3),
          // User can zoom into the map by clicking on this button
          FloatingActionButton(
              heroTag: "btn2",
              child: Icon(Icons.add),
              onPressed: () {
                zoomIn();
              },
              backgroundColor: const Color(0xff47719e)),
          SizedBox(height: 10),
          // User can zoom out of the map by clicking on this button
          FloatingActionButton(
              heroTag: "btn3",
              child: Icon(Icons.remove),
              onPressed: () {
                zoomOut();
              },
              backgroundColor: const Color(0xff47719e)),
          SizedBox(height: 10),
          // User will be directed to the emergency location on the map by clicking on this button
          FloatingActionButton(
              heroTag: "btn4",
              child: Icon(Icons.location_searching),
              onPressed: () {
                if (controller != null) {
                  controller.animateCamera(
                      CameraUpdate.newCameraPosition(new CameraPosition(
                    bearing: 192,
                    target: LatLng(widget.locationOfEmergency.latitude,
                        widget.locationOfEmergency.longitude),
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
