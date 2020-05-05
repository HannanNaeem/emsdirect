import 'package:ems_direct/models/emergency_models.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ems_direct/services/ops_manual_assignment_wrapper.dart';
import 'package:location/location.dart';

// Displays the map to OPS which contains markers to all the available MFRs, ongoing emergencies and pending emergencies.
// By clicking on a pending emergencies marker, OPS user can assign an MFR to it manually.

class MapOPS extends StatefulWidget {
  MapOPS() : super();

  @override
  MapStateOPS createState() => new MapStateOPS();
}

class MapStateOPS extends State<MapOPS> {

  // The map view is controlled using this controller
  GoogleMapController controller;

  // Used to keep track of the current location
  static LatLng currLoc = const LatLng(31.4700, 74.4111);

  // Used to track the location of the MFR
  static Location locationTracker = Location();

  // Used to keep track of the last map position
  LatLng lastMapPosition = currLoc;

  // Used to keep track of the map type - normal or satellite.
  // Initially its been set to normal
  MapType currentMapType = MapType.normal;

  // This is used to determine if the map has loaded or not - to display Circular Progress Indicator while the map is being loaded
  bool mapLoading = true;

  // will be storing list of available MFRs documents
  var availableMfrsList = [];

  // will be storing list of pending emergencies documents
  var pendingEmergenciesList = [];

  // will be storing list of ongoing emergencies documents
  var onGoingEmergenciesList;

  // Stores all markers for the map
  Map<MarkerId, Marker> allMarkers = <MarkerId, Marker>{};

  // stores the marker icon to represent pending emergencies
  var emergencyLocationIconPending = BitmapDescriptor.fromAsset(
      'assets/redcross.png');

  // stores the marker icon to represent ongoing emergencies
  var emergencyLocationIconOngoing = BitmapDescriptor.fromAsset(
      'assets/bluecross.png');

  // stores the marker icon to represent MFRs which are busy in an emergency but are marked available
  var occupiedMFR = BitmapDescriptor.fromAsset('assets/MFR_red.png');

  // stores the marker icon to represent MFRs which are not busy in an emergency and are marked available
  var notOccupiedMFR = BitmapDescriptor.fromAsset('assets/MFR_blue.png');

  // Called when the user wishes to change the map type
  onMapTypeButtonPressed() {
    setState(() {
      currentMapType = currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  // Called when the map has been created
  onMapCreated(GoogleMapController _controller){
    controller = _controller;
    // making mapLoading false so that the map can be displayed now
    setState(() => mapLoading = false);
  }

  // Called when camera is moved around so that the last map position can be updated
  onCameraMove(CameraPosition position){
    lastMapPosition = position.target;
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

  // this function makes markers for each ongoing emergency and appends it to 'allMarkers'
  void addOnGoingEmergenciesMarker() {
    if (onGoingEmergenciesList != null && onGoingEmergenciesList.length != 0) {
      onGoingEmergenciesList.forEach((EM){
        // determining marker id to add to set
        var markerIdVal = allMarkers.length + 1;
        String mar = markerIdVal.toString();
        final MarkerId markerId = MarkerId(mar);

        // creating a marker
        final Marker marker =
        Marker(
          markerId: markerId,
          position: LatLng(EM.location.latitude, EM.location.longitude),
          icon: emergencyLocationIconOngoing,
          infoWindow: InfoWindow(
              title: EM.patientRollNo,
              snippet: EM.patientContactNo
          ),
        );

        // setting the marker
        setState(() {
          allMarkers[markerId] = marker;
        });
      }
      );
    }
  }


  // this function makes markers for each pending emergency and appends it to 'allMarkers'
  void addPendingEmergenciesMarker(){
    if (pendingEmergenciesList != null && pendingEmergenciesList.length != 0) {
      pendingEmergenciesList.forEach((EM){
        // determining marker id to add to set
        var markerIdVal = allMarkers.length + 1;
        String mar = markerIdVal.toString();
        final MarkerId markerId = MarkerId(mar);

        // creating a marker
        final Marker marker =
        Marker(
          markerId: markerId,
          position: LatLng(EM.location.latitude, EM.location.longitude),
          onTap: () {
            // On tap, navigating to the manual assignment screen
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OpsManualAssignmentWrapper(EM)
                )
            );
          },
          icon: emergencyLocationIconPending,
        );

        // setting the marker
        setState(() {
          allMarkers[markerId] = marker;
        });
      }
      );
    }
  }

  // this function makes markers for each available emergency and appends it to 'allMarkers'
  void addAvailableMfrsMarker() {
    if (availableMfrsList != null && availableMfrsList.length != 0) {
      availableMfrsList.forEach((MFR) {
        // determining marker id to add to set
        var markerIdVal = allMarkers.length + 1;
        String mar = markerIdVal.toString();
        final MarkerId markerId = MarkerId(mar);

        // checking if MFR is occupied or not
        if (MFR.isOccupied) {
          // if MFR is occupied

          // creating a marker
          final Marker marker =
          Marker(
            markerId: markerId,
            position: LatLng(MFR.location.latitude, MFR.location.longitude),
            icon: occupiedMFR,
            infoWindow: InfoWindow(
                title: MFR.name,
                snippet: MFR.rollNo
            ),
          );

          // setting the marker
          setState(() {
            allMarkers[markerId] = marker;
          });
        }
        else if(!MFR.isOccupied) {
          // if MFR is not occupied

          // creating a marker
          final Marker marker =
          Marker(
            markerId: markerId,
            position: LatLng(MFR.location.latitude, MFR.location.longitude),
            infoWindow: InfoWindow(
                title: MFR.name,
                snippet: MFR.rollNo
            ),
            icon: notOccupiedMFR,
          );

          // setting the marker
          setState(() {
            allMarkers[markerId] = marker;
          });
        }
      });
    }
  }

  @override
  // Called when this object is removed from the tree permanently
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // snapshot lists
    availableMfrsList = Provider.of<List<AvailableMfrs>>(context);
    pendingEmergenciesList = Provider.of<List<PendingEmergencyModel>>(context);
    onGoingEmergenciesList = Provider.of<List<OngoingEmergencyModel>>(context);

    // Used to make screen responsive.
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    // This function is called every 1 second to update all the markers in case the lists have been updated
    // This is done because the state of MFRs and emergencies might change any time
    Timer(Duration(seconds: 1), () {
      allMarkers = <MarkerId, Marker>{};
      addPendingEmergenciesMarker();
      addAvailableMfrsMarker();
      addOnGoingEmergenciesMarker();
    });

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            // Google map widget is used to create map
            GoogleMap(
              onMapCreated: onMapCreated,
              initialCameraPosition: CameraPosition(
                target: currLoc,
                zoom: 11.0,
              ),
              mapType: currentMapType,
              markers:  Set<Marker>.of(allMarkers.values),
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
          ],
        ),
        floatingActionButton: Column(
            children: <Widget>[
              SizedBox(height: height*0.03),
              // User can change the map type by clicking on this button
              FloatingActionButton(
                  heroTag: "btn1",
                  child: Icon(Icons.map),
                  onPressed: (){
                    onMapTypeButtonPressed();
                  },
                  backgroundColor: const Color(0xff47719e)
              ),
              SizedBox(height: height/2.3),
              // User can zoom into the map by clicking on this button
              FloatingActionButton(
                  heroTag: "btn2",
                  child: Icon(Icons.add),
                  onPressed: (){
                    zoomIn();
                  },
                  backgroundColor: const Color(0xff47719e)
              ),
              SizedBox(height: 10),
              // User can zoom out of the map by clicking on this button
              FloatingActionButton(
                heroTag: "btn3",
                child: Icon(Icons.remove),
                onPressed: (){
                  zoomOut();
                },
                backgroundColor: const Color(0xff47719e),
              ),
            ]
        ),
      ),
    );
  }
}