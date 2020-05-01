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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(6, 28, 0, 20),
                  child: Icon(
                    Icons.fiber_manual_record,
                    color: color,
                    size: 15,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 24, 0, 20),
                    child: Container(                     
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(                        
                            widget.name,
                            style: TextStyle(
                              color: const Color(0xffee0000),
                              fontSize: 20,
                              fontFamily: 'HelveticaNeueLight',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              widget.contact,
                              style: TextStyle(
                                color: const Color(0xff142850),
                                fontSize: 18,
                                fontFamily: 'HelveticaNeueLight',
                              ),
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
