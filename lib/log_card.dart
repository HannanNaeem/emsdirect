import 'package:flutter/material.dart';

class LogCard extends StatefulWidget {
  String name;
  String number;
  String gender;
  String severity;
  String reportingTime;

  LogCard(String name, String number, String gender, String severity,
      String reportingTime) {
    this.name = name;
    this.number = number;
    this.gender = gender;
    this.severity = severity;
    this.reportingTime = reportingTime;
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
                      'MFR: ' + widget.name,
                      style: TextStyle(
                        color: const Color(0xff142850),
                        fontSize: 14,
                        fontFamily: 'HelveticaNeueLight',
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      'Contact: ' + widget.number,
                      style: TextStyle(
                        color: const Color(0xff142850),
                        fontSize: 14,
                        fontFamily: 'HelveticaNeueLight',
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      'Gender: ' + widget.gender,
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
