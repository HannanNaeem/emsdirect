import 'package:ems_direct/services/auth.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//This is responsible for alerting MFRs of any pending emergencies with a severity level of low/medium
class AlertFunction extends StatefulWidget {
  var availability;
  var length;
  var render;

  //the alert is recieved on the MFRs screens depending on the three variables below
  //decision: only show alert if the MFR is available, there is a pending emergency document and that document is to be rendered
  AlertFunction({this.availability, this.length, this.render});
  @override
  _AlertFunctionState createState() => _AlertFunctionState();
}

class _AlertFunctionState extends State<AlertFunction> {
  void showAlert(bool available, int num, bool render) {
    //num = 1; //FOR TESTING ALERTS BASED ON SITUATIONS WITH A NULL STREAM
    if (available == true && num > 0 && render) {
      print(render);
      print('show dialog');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Are you sure?",
            style: TextStyle(
              fontFamily: 'HelveticaNeueLight',
              letterSpacing: 2.0,
              fontSize: 20,
              //color: Colors.grey[600],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'YES',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3.0,
                  fontSize: 20,
                  color: const Color(0xff1a832a),
                ),
              ),
              onPressed: () {
                print('yes');
                //dispose();
              },
            ),
            FlatButton(
              child: Text(
                'NO',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.5,
                  fontSize: 20,
                  color: const Color(0xffee0000),
                ),
              ),
              onPressed: () {
                print('no');
                Navigator.of(context).pop();
                //dispose();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    print('widget disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('IN THIS FUNCTION');
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => showAlert(widget.availability, widget.length, widget.render));
    return Container(key: UniqueKey());
  }
}
