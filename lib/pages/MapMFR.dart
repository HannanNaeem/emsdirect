import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapMFR extends StatefulWidget {
  MapMFR() : super();

  final String title = "Map";
  @override
  MapState createState() => new MapState();

}

class MapState extends State<MapMFR> {
  GoogleMapController _controller;

  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _loc;
  MapType _currentMapType = MapType.normal;
  static Location _locationTracker = Location();
  Marker marker;
  StreamSubscription _locationSubscription;

  static const LatLng _loc = const LatLng(31.4700, 74.4111);

  _onMapCreated(GoogleMapController controller){
    _controller= controller;
  }

  _onCameraMove(CameraPosition position){
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
    target: LatLng(31.4700, -74.4111),
    zoom: 11.0,
  );

  void updateMarker(LocationData newLocation){
    LatLng values = LatLng(newLocation.latitude, newLocation.longitude);
    this.setState(
            (){
        marker = Marker(
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
    }
    );
  }

  void getCurrentLocaion() async {
    try {
      var location = await _locationTracker.getLocation();

      updateMarker(location);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }
      
      _locationSubscription = _locationTracker.onLocationChanged().listen((newLocation){
        if(_controller != null){
          _controller.animateCamera(
            CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192,
                  target: LatLng(newLocation.latitude, newLocation.longitude),
                  tilt: 0,
                  zoom: 11.0
              )
            )
          );
          updateMarker(newLocation);
        }
      });
    }
    on PlatformException catch(e){
      if(e.code == 'PERMISSION_DENIED'){
        debugPrint("Permission Denied");
      }
    }
      
  }

  @override
  void dispose(){
    if(_locationSubscription != null){
      _locationSubscription.cancel();
    }

    super.dispose();
  }
  @override

  Widget build(BuildContext context) {
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
                markers: Set.of((marker!=null) ? [marker] : []),
                onCameraMove: _onCameraMove,
              ),

            ],

          ),
          floatingActionButton:FloatingActionButton(
            child: Icon(Icons.location_searching),
            onPressed: (){
              getCurrentLocaion();
            }
        ),
      ),
    );
  }
}