import 'package:flutter/material.dart';

class EmergencyNumbers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[800],
        title: Text(
          'Emergency Numbers',
          style: TextStyle(fontFamily: 'HelveticaNeueBold', fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Center(child: Text('Numbers')),
    );
  }
}
