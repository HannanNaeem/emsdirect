import 'package:flutter/material.dart';

// Contains the single Tile class that is displayed on the Emergencies section of Ops records.

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
                      color: const Color(0xff142850),
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
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 10),
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
                      widget.primaryMfrName.split(" ")[0],
                      style: TextStyle(
                        fontFamily: "HelveticaNeueLight",
                        color: const Color(0xff27496d),
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
              //!Emergency type 
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    widget.transportUsed == "" ? Container() :
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Icon(
                        Icons.directions_bus,
                        color: Colors.grey[500],
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 0.1,
                        ),
                        
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10,5,10,5),
                        child: Text(
                          widget.emergencyType,
                          style: TextStyle(
                            fontFamily: "HelveticaNeueLight",
                            color: const Color(0xff27496d),
                            fontSize: 15,
                          )
                        ),
                      ),
                    ),
                ],)
              )
            ],
          ),
        ),
        
        children: <Widget>[
          Divider(thickness: 1,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                //! Patient Details
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  title: Text(
                      "Patient information",
                      style: TextStyle(
                        fontFamily: "HelveticaNeueLight",
                        fontSize: 17,
                      )
                  ),
                  subtitle: Text(
                      widget.patientRollNo + "  |  " + widget.patientGender + "  |  " + widget.patientIsHostelite,
                      style: TextStyle(
                        fontFamily: "HelveticaNeueLight",
                        fontSize: 15,
                      )
                  ), 
                  
                ),
                //!Emergency Details
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  title: Text(
                      "Emergency details",
                      style: TextStyle(
                        fontFamily: "HelveticaNeueLight",
                        fontSize: 17,
                      )
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //! Location                    
                      widget.emergencyLocation == "No location" ? Container() :
                      Column(
                        children: <Widget>[
                          SizedBox(height: 5,),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: Icon(
                                  Icons.location_on,
                                  size: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                widget.emergencyLocation,
                                style: TextStyle(
                                  fontFamily: "HelveticaNeueLight",
                                  fontSize: 15,
                                )
                              ),
                            ],
                          ),
                        ],
                      ),

                      //! emergency Details
                      Text(
                          widget.emergencyDetails,
                          style: TextStyle(
                            fontFamily: "HelveticaNeueLight",
                            fontSize: 15,
                          )
                      ),
                    ],
                  ), 
                  
                ),
                //!EQuipment details
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  title: Text(
                      "Equipment used",
                      style: TextStyle(
                        fontFamily: "HelveticaNeueLight",
                        fontSize: 17,
                      )
                  ),
                  subtitle: Text(
                      widget.bagUsed == "None" ? "None": widget.bagUsed + " bag\n" + widget.equipmentUsed,
                      style: TextStyle(
                        fontFamily: "HelveticaNeueLight",
                        fontSize: 15,
                      )
                  ), 
                  
                ),
                //!Back up MFRS
                widget.additionalMfrs == "None" ? Container() : 
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  title: Text(
                      "Backup MFRs",
                      style: TextStyle(
                        fontFamily: "HelveticaNeueLight",
                        fontSize: 17,
                      )
                  ),
                  subtitle: Text(
                      widget.additionalMfrs,
                      style: TextStyle(
                        fontFamily: "HelveticaNeueLight",
                        fontSize: 15,
                      )
                  ), 
                  
                ),

              ],
            ),
          ),

        ],

      ),
    );
  }
}