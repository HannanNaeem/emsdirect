import 'package:flutter/material.dart';

class AvailableMfrs extends StatefulWidget {
  @override
  _AvailableMfrsState createState() => _AvailableMfrsState();
}

class _AvailableMfrsState extends State<AvailableMfrs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[800],
        title: Text(
          'Available MFRs',
          style: TextStyle(fontFamily: 'HelveticaNeueBold', fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Center(child: Text('Numbers')),
    );
  }
}
