import 'package:flutter/material.dart';



class ReportedEmergencyTile extends StatefulWidget {
  String patientRollNo; 
  String patientGender; 
  String emergencyDate; 
  String primaryMfrRollNo; 
  String primaryMfrName; 
  String additionalMfrs; 
  String severity; 
  String patientIsHostelite;
  String emergencyType; 
  String emergencyLocation;
  String transportUsed;
  String emergencyDetails; 
  String bagUsed;
  String equipmentUsed;

  ReportedEmergencyTile({
    this.patientRollNo, 
    this.patientGender, 
    this.emergencyDate, 
    this.primaryMfrRollNo, 
    this.primaryMfrName, 
    this.additionalMfrs, 
    this.severity, 
    this.patientIsHostelite,
    this.emergencyType, 
    this.emergencyLocation,
    this.transportUsed,
    this.emergencyDetails, 
    this.bagUsed,
    this.equipmentUsed,
  });

  @override
  _ReportedEmergencyTileState createState() => _ReportedEmergencyTileState();
}

class _ReportedEmergencyTileState extends State<ReportedEmergencyTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.emergencyDate,
        style: TextStyle(
          fontFamily: "HelveticaNeueLight",
        )
      ),

      subtitle: Text(
        widget.primaryMfrName + " " + widget.severity,
        style: TextStyle(
          fontFamily: "HelveticaNeueLight",
        )
      ),
      
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              widget.emergencyDetails,
              style: TextStyle(
                fontFamily: "HelveticaNeueLight",
              )
            ),

        ],),
      ],

    );
  }
}