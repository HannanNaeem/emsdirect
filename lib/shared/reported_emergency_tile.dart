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

  Color _severityToColor(String inSeverity){
    switch (inSeverity) {
      case "Low" : {return Colors.yellow[700];}
      case "Medium" : {return Colors.amber[800];}
      case "High" : {return Colors.orange[900];}
      default: {return Colors.red[800];}
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
        child: ExpansionTile(
        
        title: Row(
          children: <Widget>[
            //! Date title
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 0, 10),
                  child: Text(
                    widget.emergencyDate,
                    style: TextStyle(
                      fontFamily: "HelveticaNeueLight",
                      fontSize: 24,
                    )
                  ),
                ),
              ],
            ),

            //! severity bubble
            Expanded(
                child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 15, 0, 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: _severityToColor(widget.severity)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10,5,10,5),
                        child: Text(
                          widget.severity,
                          style: TextStyle(
                            fontFamily: "HelveticaNeueLight",
                            fontSize: 15,
                            color: Colors.white,
                          )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 10, 10),
          child: Row(
            children: <Widget>[
              //!mfr icon
              Icon(
                Icons.person,
                size: 30,
                color: const Color(0xff27496d),
              ),
              //!mfr info
              Padding(
                padding: const EdgeInsets.fromLTRB(5,0,0,0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //! name
                    Text(
                      widget.primaryMfrName,
                      style: TextStyle(
                        fontFamily: "HelveticaNeueLight",
                        fontSize: 15,
                      )
                    ),
                    //! Roll no
                   Text(
                      widget.primaryMfrRollNo,
                      style: TextStyle(
                        fontFamily: "HelveticaNeueLight",
                        fontSize: 13,
                        color: Colors.grey[500],
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            child: Column(
              children: <Widget>[
                Text(
                  widget.emergencyDetails,
                  style: TextStyle(
                    fontFamily: "HelveticaNeueLight",
                  )
                ),

            ],),
          ),
        ],

      ),
    );
  }
}