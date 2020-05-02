import 'package:flutter/material.dart';


class ManualAssignment extends StatefulWidget {
  var _emergencyInformation;
  ManualAssignment(var EmergencyInformation) : super() {
    _emergencyInformation = EmergencyInformation;
  }

  @override
  ManualAssignmentState createState() => new ManualAssignmentState(_emergencyInformation);
}

class ManualAssignmentState extends State<ManualAssignment> {
  @override
  var _emergencyInformation;
  ManualAssignmentState(var EmergencyInformation) {
    _emergencyInformation = EmergencyInformation;
  }

  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff142850),
            title: Text(
              'Manual Assignment',
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
        )
    );
  }
}