import 'package:flutter/material.dart';

class LogCard extends StatefulWidget {
  String name;
  String number;
  String gender;
  String severity;
  String time;

  LogCard(String name, String number, String gender, String severity, String time) {
    this.name = name;
    this.number = number;
    this.gender = gender;
    this.severity = severity;
    this.time = time;
  }

  @override
  _LogCardState createState() => _LogCardState();
}

class _LogCardState extends State<LogCard> {
  
  Color GenerateColor(String severity) {
    if (severity == 'low') {
      return Colors.yellow[400];
    }
    if (severity == 'medium') {
      return Colors.amber[600];
    }
    if (severity == 'high') {
      return Colors.orange[800];
    } else {
      return Colors.red;
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
          Flexible(
            flex: 6,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(6, 25, 0, 20),
                  child: Icon(
                    Icons.fiber_manual_record,
                    color: color,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 25, 0, 20),
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
                            ),
                          ),
                          Text(
                            'Contact: ' + widget.number,
                            style: TextStyle(
                              color: const Color(0xff142850),
                              fontSize: 14,
                              fontFamily: 'HelveticaNeueLight',
                            ),
                          ),
                          Text(
                            'Gender: ' + widget.gender,
                            style: TextStyle(
                              color: const Color(0xff142850),
                              fontSize: 14,
                              fontFamily: 'HelveticaNeueLight',
                            ),
                          ),
                          Text(
                            'Severity: ' + widget.severity,
                            style: TextStyle(
                              color: const Color(0xff142850),
                              fontSize: 14,
                              fontFamily: 'HelveticaNeueLight',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                widget.time,
                style: TextStyle(
                  color: const Color(0xff142850),
                  fontSize: 12,
                  fontFamily: 'HelveticaNeueLight',
                ),
              ),
            ),

          ),
//           Flexible(
//             flex: 1,
//             child: IconButton(
//               color: Colors.grey[700],
//               icon: Icon(Icons.cancel),
//               onPressed: () {
//                 print('Delete notification');
// //                setState(() {
// //                  data.removeAt(index);
// //                });
//               },
//             ),
//           ),
        ],
      ),
    );
  }
}
