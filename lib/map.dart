import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/models/emergency_models.dart';
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
  Map<MarkerId, Marker> allMarkers = <MarkerId, Marker>{};
  LatLng _lastMapPosition = _loc;
  MapType _currentMapType = MapType.normal;
  var _availableMfrsList;
  var _pendingEmergenciesList;
  var _onGoingEmergenciesList;
  bool _mapLoading = true;



  static final CameraPosition _position1 = CameraPosition(
    bearing: 192.833,
    target: LatLng(31.4700, 74.4111),
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
                child: Icon(Icons.map),
                onPressed: (){
                  _onMapTypeButtonPressed();
                },
                  backgroundColor: const Color(0xff47719e)
              ),
              SizedBox(height: height/2.3),
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
            ]
        ),
      ),
    );
  }


  void _addOnGoingEmergenciesMarker(_onGoingEmergenciesList) async {
    if (_onGoingEmergenciesList != null && _onGoingEmergenciesList.length != 0) {
      print('here lol');
      _onGoingEmergenciesList.forEach((EM){
        debugPrint('hello');
        GeoPoint location = EM.location;
        String rollNumber = EM.patientRollNo;
        String severity = EM.severity;
        var markerIdVal = allMarkers.length + 1;
        String mar = markerIdVal.toString();
        final MarkerId markerId = MarkerId(mar);
        final Marker marker =
            Marker(
              markerId: markerId,
              position: LatLng(location.latitude, location.longitude),

            );
        setState(() {
          allMarkers[markerId] = marker;
        });
      }
      );
    }
  }


  void _addPendingEmergenciesMarker(_pendingEmergenciesList){

    if (_pendingEmergenciesList != null && _pendingEmergenciesList.length != 0) {
      print('here lol2');
      _pendingEmergenciesList.forEach((EM){
        GeoPoint location = EM.location;
        String rollNumber = EM.patientRollNo;
        String severity = EM.severity;
        var markerIdVal = allMarkers.length + 1;
        String mar = markerIdVal.toString();
        final MarkerId markerId = MarkerId(mar);
        final Marker marker =
        Marker(
            markerId: markerId,
            position: LatLng(location.latitude, location.longitude),
            onTap: () {
                print('Roll Number: ');
                print(rollNumber);
                print('\nSeverity: ');
                print(severity);
                print('PLEASE ASSIGN AN MFR.');
                // todo: assign MFR option
              },
            );
            setState(() {
                allMarkers[markerId] = marker;
            });
        }
      );
    }
  }


  void _addAvailableMfrsMarker(_availableMfrsList) {
    if (_availableMfrsList != null && _availableMfrsList.length != 0) {
      print('here lol444');
      _availableMfrsList.forEach((MFR) {
        GeoPoint location = MFR.location;
        String name = MFR.name;
        String contact = MFR.contact;
//        String rollNumber = MFR.roll;
        bool busy = _availableMfrsList.isOccupied;
        var markerIdVal = allMarkers.length + 1;
        String mar = markerIdVal.toString();
        final MarkerId markerId = MarkerId(mar);
        print('BUSY: ');
        print(busy);
        if (busy == true) {
          print('hmmmmmmsigh');
          final Marker marker =
          Marker(
              markerId: markerId,
              position: LatLng(location.latitude, location.longitude),

//              infoWindow: InfoWindow( title: name, snippet: rollNumber)


          );
          setState(() {
            allMarkers[markerId] = marker;
          });
        }
        else if(busy == false) {
          print('lol');
          final Marker marker =
          Marker(
            markerId: markerId,
            position: LatLng(location.latitude, location.longitude),
            onTap: (){
              print('hmmm');
            },
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue,),
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
    this.setState(() => _mapLoading = false);
    print('helloooooo');
    _addAvailableMfrsMarker(_availableMfrsList);
    _addPendingEmergenciesMarker(_pendingEmergenciesList);
    _addOnGoingEmergenciesMarker(_onGoingEmergenciesList);
  }

  _onCameraMove(CameraPosition position){
    _lastMapPosition = position.target;
  }

//
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



}