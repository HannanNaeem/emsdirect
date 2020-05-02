import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/models/emergency_models.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ems_direct/services/ops_manual_assignment_wrapper.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

class MapOPS extends StatefulWidget {
  MapOPS() : super();
  final String title = "Map";

  @override
  MapStateOPS createState() => new MapStateOPS();

}

class MapStateOPS extends State<MapOPS> {
  GoogleMapController _controller;
  static const LatLng _loc = const LatLng(31.4700, 74.4111);
  LatLng currLoc = _loc;
  static Location _locationTracker = Location();
  static var Zoom = 11.0;
  bool _mapLoading = true;
  var _availableMfrsList;
  var _pendingEmergenciesList;
  var _onGoingEmergenciesList;
  Map<MarkerId, Marker> allMarkers = <MarkerId, Marker>{};
  var EmergencyLocationIconRed = BitmapDescriptor.fromAsset(
      'assets/redcross.png');
  var EmergencyLocationIconBlue = BitmapDescriptor.fromAsset(
      'assets/bluecross.png');
  var RedMFR = BitmapDescriptor.fromAsset('assets/MFR_red.png');
  var BlueMFR = BitmapDescriptor.fromAsset('assets/MFR_blue.png');
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
  void dispose(){
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // ----------------------------- snapshot lists ---------------------------------//

    _availableMfrsList = Provider.of<List<AvailableMfrs>>(context);
    _pendingEmergenciesList = Provider.of<List<PendingEmergencyModel>>(context);
    _onGoingEmergenciesList = Provider.of<List<OngoingEmergencyModel>>(context);

    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    if(_availableMfrsList != null) {_availableMfrsList.forEach((mfr){print("-------------------------${mfr.name}");});}

    Timer(Duration(seconds: 1), () {
      allMarkers = <MarkerId, Marker>{};
      _addPendingEmergenciesMarker(_pendingEmergenciesList);
      _addAvailableMfrsMarker(_availableMfrsList);
      _addOnGoingEmergenciesMarker(_onGoingEmergenciesList);
    });
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
              markers:  Set<Marker>.of(allMarkers.values),
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
          ],
        ),
        floatingActionButton: Column(
            children: <Widget>[
              SizedBox(height: height*0.03),
              FloatingActionButton(
                  heroTag: "btn1",
                  child: Icon(Icons.map),
                  onPressed: (){
                    _onMapTypeButtonPressed();
                  },
                  backgroundColor: const Color(0xff47719e)
              ),
              SizedBox(height: height/2.3),
              FloatingActionButton(
                  heroTag: "btn2",
                  child: Icon(Icons.add),
                  onPressed: (){
                    zoomIn();
                  },
                  backgroundColor: const Color(0xff47719e)
              ),
              SizedBox(height: 10),
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


  void _addOnGoingEmergenciesMarker(_onGoingEmergenciesList) {
    if (_onGoingEmergenciesList != null && _onGoingEmergenciesList.length != 0) {
      _onGoingEmergenciesList.forEach((EM){
        GeoPoint location = EM.location;
        String rollNumber = EM.patientRollNo;
        String contact = EM.patientContactNo;
        var markerIdVal = allMarkers.length + 1;
        String mar = markerIdVal.toString();
        final MarkerId markerId = MarkerId(mar);
        final Marker marker =
        Marker(
          markerId: markerId,
          position: LatLng(location.latitude, location.longitude),
          icon: EmergencyLocationIconBlue,
          infoWindow: InfoWindow(
            title: rollNumber,
            snippet: contact
          ),
        );
        setState(() {
          allMarkers[markerId] = marker;
        });
      }
      );
    }
  }


  void _addPendingEmergenciesMarker(_pendingEmergenciesList){
    debugPrint("PENDING EMERGENCIES");
    if (_pendingEmergenciesList != null && _pendingEmergenciesList.length != 0) {
      _pendingEmergenciesList.forEach((EM){
        debugPrint("PENDING EMERGENCIES");
        GeoPoint location = EM.location;
        String rollNumber = EM.patientRollNo;
        String contact = EM.patientContactNo;
        var markerIdVal = allMarkers.length + 1;
        String mar = markerIdVal.toString();
        final MarkerId markerId = MarkerId(mar);
        final Marker marker =
        Marker(
          markerId: markerId,
          position: LatLng(location.latitude, location.longitude),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OpsManualAssignmentWrapper(EM)
                )
            );
          },
          icon: EmergencyLocationIconRed,
        );
        setState(() {
          allMarkers[markerId] = marker;
        });
      }
      );
    }
  }


  void _addAvailableMfrsMarker(_availableMfrsList) {
    print('hmmmm:(');
    if (_availableMfrsList != null && _availableMfrsList.length != 0) {
      print('here lol444');
      _availableMfrsList.forEach((MFR) {
        GeoPoint location = MFR.location;
        String name = MFR.name;
        String rollNo = MFR.rollNo;
        bool busy = MFR.isOccupied;
        var markerIdVal = allMarkers.length + 1;
        String mar = markerIdVal.toString();
        final MarkerId markerId = MarkerId(mar);
        print(busy);
        if (busy) {
          final Marker marker =
          Marker(
            markerId: markerId,
            position: LatLng(location.latitude, location.longitude),
            icon: RedMFR,
//              infoWindow: InfoWindow( title: name, snippet: rollNumber)


          );
          setState(() {
            allMarkers[markerId] = marker;
          });
        }
        else if(!busy) {
          print('lol');
          final Marker marker =
          Marker(
            markerId: markerId,
            position: LatLng(location.latitude, location.longitude),
            onTap: (){
              print('hmmm');
            },
            infoWindow: InfoWindow(
                title: name,
                snippet: rollNo
            ),
            icon: BlueMFR,
          );
          setState(() {
            allMarkers[markerId] = marker;
          });
        }
      });
    }
  }

  _onMapCreated(GoogleMapController controller){
    _controller=controller;
    setState(() => _mapLoading = false);
  }

  _onCameraMove(CameraPosition position){
    _lastMapPosition = position.target;
  }

//
  void zoomIn() async {
    Zoom = Zoom*1.25;
    _controller.animateCamera(
      CameraUpdate.zoomIn(),
    );
  }

  void zoomOut() async {
    Zoom = Zoom*0.75;
    _controller.animateCamera(
      CameraUpdate.zoomOut(),
    );
  }




}