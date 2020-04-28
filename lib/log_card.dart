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
  Color GenerateColor(String severity) {
    if (severity == 'low') {
      return Colors.yellow[300];
    }
    if (severity == 'medium') {
      return Colors.amber[600];
    }
    if (severity == 'high') {
      return Colors.orange[800];
    } else {
      return Colors.red[800];
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = GenerateColor(widget.severity);

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
                    Text(
                      'MFR: ' + widget.mfrName + ' ' + widget.mfrRollNo,
                      style: TextStyle(
                        color: const Color(0xff142850),
                        fontSize: 14,
                        fontFamily: 'HelveticaNeueLight',
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      'Contact: ' + widget.mfrContact,
                      style: TextStyle(
                        color: const Color(0xff142850),
                        fontSize: 14,
                        fontFamily: 'HelveticaNeueLight',
                        letterSpacing: 1,
                      ),
                    ),
                    Divider(),
                    Text(
                      'Patient: ' + widget.patientRollNo,
                      style: TextStyle(
                        color: const Color(0xff142850),
                        fontSize: 14,
                        fontFamily: 'HelveticaNeueLight',
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      'Patient Contact: ' + widget.patientContactNo,
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
                    Text(
                      'Severity: ' + widget.severity,
                      style: TextStyle(
                        color: const Color(0xff142850),
                        fontSize: 14,
                        fontFamily: 'HelveticaNeueLight',
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      'Reporting time: ' + widget.reportingTime,
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
