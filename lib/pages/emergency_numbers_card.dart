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
      elevation: 6,
      child: ListTile(
        title: Text(
          widget.name,
          style: TextStyle(
            letterSpacing: 2.0,
            fontFamily: 'HelveticaNeueLight',
            color: Color(0xff142850),
          )
        ),
        subtitle: Text(
          widget.contact,
          style: TextStyle(
            letterSpacing: 2.0,
            fontFamily: 'HelveticaNeueLight',
          )
        ),
      ),
    );
  }
}



class EmergencyNumbersData {

  static final data = [
    {
      'name': 'EMS-1',
      'contact': '03000000000',
    },
    {
      'name': 'EMS-2',
      'contact': '03000000000',
    },
    {
      'name': 'EMS-3',
      'contact': '03000000000',
    },
    {
      'name': 'EMS-4',
      'contact': '03000000000',
    },
    {
      'name': 'LUMS',
      'contact': '03000000000',
    },
    {
      'name': 'HAWC',
      'contact': '03000000000',
    },
       {
      'name': 'LUMS Security Desk',
      'contact': '03000000000',
    },
  ];
}

