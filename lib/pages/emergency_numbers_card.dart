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
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListTile(
          title: Text(
            widget.name,
            style: TextStyle(
              letterSpacing: 1.0,
              fontFamily: 'HelveticaNeueLight',
              color: Color(0xff142850),
              fontSize: 18,
            )
          ),
          subtitle: Text(
            widget.contact,
            style: TextStyle(
              letterSpacing: 3.0,
              fontFamily: 'HelveticaNeueLight',
              fontSize: 24,
            )
          ),
        ),
      ),
    );
  }
}

