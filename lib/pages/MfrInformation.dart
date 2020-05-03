import 'package:ems_direct/models/emergency_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/services/ops_database.dart';

class MfrInformation extends StatefulWidget {
  String name;
  String rollNo;
  String contact;
  bool isSenior;
  String gender;
  var _emergencyInformation;

  MfrInformation(String mfrName, String mfrRollNo ,String mfrContact, String Gender, bool IsSenior, var EmergencyInformation) {
    this.name = mfrName;
    this.rollNo = mfrRollNo;
    this.contact = mfrContact;
    this.gender = Gender;
    this.isSenior = IsSenior;
    this._emergencyInformation = EmergencyInformation;
  }

  @override
  _MfrInformationState createState() => _MfrInformationState();
}


class _MfrInformationState extends State<MfrInformation> {
  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    final document = Firestore.instance;

    return CupertinoButton(
      child: Container(
        height: 0.15*height,
        width: 0.9*width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Container(

          margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Column(
          children: <Widget>[
            Text(
              'MFR: ' + widget.name + ' ' + widget.rollNo,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xff142850),
                fontSize: 14,
                fontFamily: 'HelveticaNeueLight',
                letterSpacing: 1,
              ),
            ),
            Text(
              'Contact: ' + widget.contact,
                textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xff142850),
                fontSize: 14,
                fontFamily: 'HelveticaNeueLight',
                letterSpacing: 1,
              ),
            ),
            Text(
              'Gender: ' + widget.gender,
                textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xff142850),
                fontSize: 14,
                fontFamily: 'HelveticaNeueLight',
                letterSpacing: 1,
              ),
            ),
            Text(
              'Senior: ' + widget.isSenior.toString(),
                textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xff142850),
                fontSize: 14,
                fontFamily: 'HelveticaNeueLight',
                letterSpacing: 1,
              ),
            ),
          ]
        ),
      ),

    ),
      onPressed: () {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) =>
              AlertDialog(
                title: Text(
                  "Do you want to assign this MFR?",
                  style: TextStyle(
                    fontFamily: 'HelveticaNeueLight',
                    letterSpacing: 2.0,
                    fontSize: 20,
                    color: Colors.grey[600],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'YES',
                      style: TextStyle(
                        fontFamily: 'HelveticaNeueLight',
                        letterSpacing: 3.0,
                        fontSize: 20,
                        color: const Color(0xff1a832a),
                      ),
                    ),
                    onPressed: () {
                      //todo: assign MFR
                      Update();
                      Navigator.of(context).pop();
                      },
                  ),
                  FlatButton(
                    child: Text(
                      'NO',
                      style: TextStyle(
                        fontFamily: 'HelveticaNeueLight',
                        letterSpacing: 2.5,
                        fontSize: 20,
                        color: const Color(0xffee0000),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
        );
      },
    );
  }


  Future<bool> Update() async {
    DocumentReference document1 = Firestore.instance.collection("PendingEmergencies").document(widget._emergencyInformation.patientRollNo);
    Map map = new Map();
    map['contact'] = widget.contact;
    map['name'] = widget.name;
    Firestore.instance.runTransaction((transaction) async {
      await transaction
          .delete(document1)
          .catchError((e) {})
          .whenComplete(() {});
      await Firestore.instance
          .collection("OngoingEmergencies")
          .document(widget._emergencyInformation.patientRollNo)
          .setData({
            'genderPreference' : widget._emergencyInformation.genderPreference,
              'location' : widget._emergencyInformation.location,
              'mfr' : widget.rollNo,
              'mfrDetails' : map,
              'patientContactNo' : widget._emergencyInformation.patientContactNo,
              'patientRollNo' : widget._emergencyInformation.patientRollNo,
              'reportingTime' : widget._emergencyInformation.reportingTime,
              'severity' : widget._emergencyInformation.severity
          })
          .catchError((e) {})
          .whenComplete(() {});
    }).catchError((e) {
      return false;
    });

    return true;
  }

}
