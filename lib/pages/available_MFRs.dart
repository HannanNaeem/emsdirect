import 'package:flutter/material.dart';

class AvailableMfrs extends StatefulWidget {
  @override
  _AvailableMfrsState createState() => _AvailableMfrsState();
}

class _AvailableMfrsState extends State<AvailableMfrs> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return Scaffold(
      backgroundColor: const Color(0xff27496d),
      appBar: AppBar(
        backgroundColor: const Color(0xff142850),
        title: Text(
          'Available MFRs',
          style: TextStyle(
            fontFamily: 'HelveticaNeueLight',
            letterSpacing: 2.0,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(child: Text('Numbers')),
    );
  }
}
