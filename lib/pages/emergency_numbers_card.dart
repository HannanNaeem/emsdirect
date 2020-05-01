import 'package:flutter/material.dart';

class EmergencyNumberCard extends StatefulWidget {
  String name;
  String contact;


  EmergencyNumberCard(String name, String contact) {
    this.name = name;
    this.contact = contact;
  }

  @override
  _EmergencyNumberCardState createState() => _EmergencyNumberCardState();
}

class _EmergencyNumberCardState extends State<EmergencyNumberCard> {

  @override
  Widget build(BuildContext context) {
    Color color = Colors.red;

    return Card(
      elevation: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(6, 24, 0, 20),
                  child: Icon(
                    Icons.fiber_manual_record,
                    color: color,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 25, 0, 20),
                    child: Container(                     
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(                        
                            widget.name,
                            style: TextStyle(
                              color: const Color(0xffee0000),
                              fontSize: 20,
                              fontFamily: 'HelveticaNeueLight',
                            ),
                          ),
                          Text(
                            widget.contact,
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
        ],
      ),
    );
  }
}
