import 'package:flutter/material.dart';

class LogCard extends StatefulWidget {
  String mfrName;
  String mfrRollNo;
  String mfrContact;
  String genderPreference;
  String severity;
  String reportingTime;
  String patientRollNo;
  String patientContactNo;

  LogCard(String mfrName, String mfrRollNo ,String mfrContact, String genderPreference, String severity,
      String reportingTime, String patientRollNo, String patientContactNo) {
    this.mfrName = mfrName;
    this.mfrRollNo = mfrRollNo;
    this.mfrContact = mfrContact;
    this.genderPreference = genderPreference;
    this.severity = severity;
    this.reportingTime = reportingTime;
    this.patientRollNo = patientRollNo;
    this.patientContactNo = patientContactNo;
  }

  @override
  _LogCardState createState() => _LogCardState();
}

class _LogCardState extends State<LogCard> {
  
  Color generateColor(String severity) {
    switch (severity) {
      case "low" : {return Colors.yellow[700];}
      case "medium" : {return Colors.amber[800];}
      case "high" : {return Colors.orange[900];}
      default: {return Colors.red[800];}
    }
  }
  

  @override
  Widget build(BuildContext context) {
    Color color = generateColor(widget.severity);

    return Card(
      elevation: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(6, 20, 0, 20),
            child: Icon(
              Icons.fiber_manual_record,
              color: color,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        //!Mfr Icon
                        Icon(
                          Icons.person,
                          size: 50,
                          color: const Color(0xff27496d),
                        ),
                        //! Mfr Info
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5,0,0,0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.mfrName,
                                style: TextStyle(
                                  fontFamily: "HelveticaNeueLight",
                                  color: const Color(0xff27496d),
                                  fontSize: 15,
                                )
                              ),
                              Text(
                                  widget.mfrRollNo,
                                  style: TextStyle(
                                    fontFamily: "HelveticaNeueLight",
                                    fontSize: 13,
                                    color: Colors.grey[500],
                                  )
                              ),
                              Text(
                                  widget.mfrContact,
                                  style: TextStyle(
                                    fontFamily: "HelveticaNeueLight",
                                    fontSize: 13,
                                    color: Colors.grey[500],
                                  )
                              ),
                            ],
                          ),
                        ),
                        //! Severity bubble
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                //! reported time
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                                  child: Text(
                                    widget.reportingTime,
                                    style: TextStyle(
                                      color: const Color(0xff142850),
                                      fontSize: 12,
                                      fontFamily: 'HelveticaNeueLight',
                                    ),        
                                  ),
                                ),

                                Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 5, 30, 5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: generateColor(widget.severity)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(10,5,10,5),
                                        child: Text(
                                          widget.severity[0].toUpperCase() + widget.severity.substring(1),
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
                              ],
                            ),
                        ),


                      ],
                    ),

                    Divider(),
                    //! Patient information
                    Text(
                      'Patient Details: ',
                      style: TextStyle(
                        color: const Color(0xff142850),
                        fontSize: 14,
                        fontFamily: 'HelveticaNeueLight',
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      widget.patientRollNo,
                      style: TextStyle(
                        color: const Color(0xff142850),
                        fontSize: 14,
                        fontFamily: 'HelveticaNeueLight',
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      widget.patientContactNo,
                      style: TextStyle(
                        color: const Color(0xff142850),
                        fontSize: 14,
                        fontFamily: 'HelveticaNeueLight',
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      'Gender Preference: ' + widget.genderPreference,
                      style: TextStyle(
                        color: const Color(0xff142850),
                        fontSize: 14,
                        fontFamily: 'HelveticaNeueLight',
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
