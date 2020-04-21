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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height / 10),
        child: AppBar(
          backgroundColor: const Color(0xff3596b5),
          title: Text(
            'Available MFRs',
            style: TextStyle(
                fontFamily: 'HelveticaNeue',
                fontWeight: FontWeight.bold,
                letterSpacing: 3.0,
                fontSize: 28),
          ),
          centerTitle: true,
        ),
      ),
      body: Center(child: Text('Numbers')),
    );
  }
}
