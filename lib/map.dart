import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/models/emergency_models.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class OpsMap extends StatefulWidget {
  OpsMap() : super();
  @override
  MapStateOPS createState() => new MapStateOPS();

}

class MapStateOPS extends State<OpsMap> {
  GoogleMapController _controller;
  static const LatLng _loc = const LatLng(31.4700, 74.4111);
  LatLng currLoc = _loc;
  static Location _locationTracker = Location();
  static var Zoom = 11.0;
  List<Marker> allMarkers = [];
  LatLng _lastMapPosition = _loc;
  MapType _currentMapType = MapType.normal;

  static final CameraPosition _position1 = CameraPosition(
    bearing: 192.833,
    target: LatLng(45.531563, -122.677433),
    tilt: 59.440,
    zoom: 11.0,
  );

  _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }
  void getCurrentLocaion() async {
    try {
      var location = await _locationTracker.getLocation();

      currLoc = LatLng(location.latitude, location.longitude);

      _controller.animateCamera(
          CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192,
                  target: currLoc,
                  tilt: 0,
                  zoom: Zoom
              )
          )
      );
    }
    on PlatformException catch(e){
      if(e.code == 'PERMISSION_DENIED'){
        debugPrint("Permission Denied");
      }
    }

  }
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    // ----------------------------- snapshot lists ---------------------------------//
//    var _availableMfrsList = Provider.of<List<AvailableMfrs>>(context);
//    var _pendingEmergenciesList = Provider.of<List<PendingEmergencyModel>>(context);
//    var _onGoingEmergenciesList = Provider.of<List<OngoingEmergencyModel>>(context);
//
//    _addAvailableMfrsMarker(_availableMfrsList);
//    _addPendingEmergenciesMarker(_pendingEmergenciesList);
//    _addOnGoingEmergenciesMarker(_onGoingEmergenciesList);
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _loc,
                zoom: 11.0,
              ),
              mapType: _currentMapType,
              markers:  Set.from(allMarkers),
              onCameraMove: _onCameraMove,
            ),
          ],
        ),
        floatingActionButton: Column(
            children: <Widget>[
              SizedBox(height: height*0.03),
              FloatingActionButton(
                child: Icon(Icons.map),
                onPressed: (){
                  _onMapTypeButtonPressed();
                },
                  backgroundColor: const Color(0xff47719e)
              ),
              SizedBox(height: height/2.8),
              FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: (){
                  zoomIn();
                },
                  backgroundColor: const Color(0xff47719e)
              ),
              SizedBox(height: 10),
              FloatingActionButton(
                child: Icon(Icons.remove),
                onPressed: (){
                  zoomOut();
                },
                backgroundColor: const Color(0xff47719e),
              ),

              SizedBox(height: 10),
              FloatingActionButton(
                child: Icon(Icons.location_searching),
                onPressed: (){
                  getCurrentLocaion();
                },
                backgroundColor: const Color(0xff47719e),
              ),
            ]
        ),
      ),
    );
  }


  _addOnGoingEmergenciesMarker(_onGoingEmergenciesList){
    for(var x = 0; x < _onGoingEmergenciesList.length; x++) {
      GeoPoint location = _onGoingEmergenciesList[x].location;
      String rollNumber = _onGoingEmergenciesList[x].patientRollNo;
      String assignedMFR = _onGoingEmergenciesList[x].mfr;
      String severity = _onGoingEmergenciesList[x].severity;

      allMarkers.add(
          Marker(
            markerId: MarkerId(location.toString()),
            position: LatLng(location.latitude, location.longitude),
            onTap: () {
              print('Roll Number: ');
              print(rollNumber);
              print('\nSeverity: ');
              print(severity);
              print('\nAssigned MFR: ');
              print(assignedMFR);
            },
            icon: BitmapDescriptor.fromAsset("images/cross.png"),
          )
      );
    }
  }


  _addPendingEmergenciesMarker(_pendingEmergenciesList){
    for(var x = 0; x < _pendingEmergenciesList.length; x++) {
      GeoPoint location = _pendingEmergenciesList[x].location;
      String rollNumber = _pendingEmergenciesList[x].patientRollNo;
      String severity = _pendingEmergenciesList.severity;

      allMarkers.add(
          Marker(
            markerId: MarkerId(location.toString()),
            position: LatLng(location.latitude, location.longitude),
            onTap: () {
              print('Roll Number: ');
              print(rollNumber);
              print('\nSeverity: ');
              print(severity);
              print('PLEASE ASSIGN AN MFR.');
              // todo: assign MFR option
            },
            icon: BitmapDescriptor.fromAsset("images/cross.png"),
          )
      );
    }
  }


  _addAvailableMfrsMarker(_availableMfrsList) {
    for (var x = 0; x < _availableMfrsList.length; x++) {
      GeoPoint location = _availableMfrsList[x].location;
      String name = _availableMfrsList[x].name;
      String gender = _availableMfrsList[x].gender;

      bool busy = _availableMfrsList.isOccupied;

      if (busy == 1) {
        allMarkers.add(
            Marker(
                markerId: MarkerId(location.toString()),
                position: LatLng(location.latitude, location.longitude),
                onTap: () {
                  print('Name: ');
                  print(name);
                  print('\nGender: ');
                  print(gender);
                },
                icon:  BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
            )
        );
      }
      else {
        allMarkers.add(
            Marker(
              markerId: MarkerId(location.toString()),
              position: LatLng(location.latitude, location.longitude),
              onTap: () {
                print('Name: ');
                print(name);
                print('\nGender: ');
                print(gender);
              },
            )
        );
      }
    }
  }

  _onMapCreated(GoogleMapController controller){
    _controller=controller;
  }

  _onCameraMove(CameraPosition position){
    _lastMapPosition = position.target;
  }


  void zoomIn() async {
    Zoom = Zoom*1.25;
    _controller.animateCamera(
        CameraUpdate.newCameraPosition(
            new CameraPosition(
                bearing: 192,
                target: LatLng(currLoc.latitude, currLoc.longitude),
                tilt: 0,
                zoom: Zoom
            )
        )
    );
  }

  void zoomOut() async {
    Zoom = Zoom*0.75;
    _controller.animateCamera(
        CameraUpdate.newCameraPosition(
            new CameraPosition(
                bearing: 192,
                target: LatLng(currLoc.latitude, currLoc.longitude),
                tilt: 0,
                zoom: Zoom
            )
        )
    );
  }




}