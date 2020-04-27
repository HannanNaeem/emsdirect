import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapMFR extends StatefulWidget {
  MapMFR() : super();
  final String title = "Map";

  @override
  MapState createState() => new MapState();

}

class MapState extends State<MapMFR> {
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);
//  final Set<Marker> _markers = {};
  List<Marker> allMarkers = [];
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;

  static final CameraPosition _position1 = CameraPosition(
    bearing: 192.833,
    target: LatLng(45.531563, -122.677433),
    tilt: 59.440,
    zoom: 11.0,
  );
  @override
  void initState(){
    super.initState();
    allMarkers.add(
      Marker(
        markerId: MarkerId('marker'),
        draggable: false,
        onTap: () {
          print('information');
        },
        //position: LatLng(latitude, longitude)
      )
    );
  }
  _onMapCreated(GoogleMapController controller){
    _controller.complete(controller);
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

//  _onAddMarkerButtonPressed(){
//    setState(() {
//      _markers.add(
//          Marker(
//            markerId: MarkerId(_lastMapPosition.toString()),
//            position: _lastMapPosition,
//            infoWindow: InfoWindow(
//              title: 'Information comes here',
//            ),
//            icon: BitmapDescriptor.defaultMarker,
//          )
//      );
//    });
//  }


  Widget button(Function function, IconData icon){
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: const Color(0xff27496d),
      child: Icon(
        icon,
        size: 36.0,
      ),
    );
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
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
                mapType: _currentMapType,
                markers:  Set.from(allMarkers),
                onCameraMove: _onCameraMove,
              ),
//              Padding(
//                  padding: EdgeInsets.all(16.0),
//                  child: Align(
//                      alignment: Alignment.topRight,
//                      child: Column(
//                        children: <Widget>[
//                          button(
//                              _onAddMarkerButtonPressed,
//                              Icons.add_location
//                          ),
//                        ],
//                      )
//                  )
//              )
            ],
          )
      ),
    );
  }
}