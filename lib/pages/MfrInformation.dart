import 'package:ems_direct/pages/MFR_home.dart';
import 'package:ems_direct/services/pending_emergency_alert_MFR.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

// Forms a clickable card for an MFR on the Assign MFR screen

class MfrInformation extends StatefulWidget {
  // variables for information about the MFR
  String name;
  String rollNo;
  String contact;
  bool isSenior;
  String gender;

  // stores information about the emergency
  var emergencyInformation;

  // Constructor
  MfrInformation(String mfrName, String mfrRollNo ,String mfrContact, String gen, bool isSen, var emergencyInfo) {
    this.name = mfrName;
    this.rollNo = mfrRollNo;
    this.contact = mfrContact;
    this.gender = gen;
    this.isSenior = isSen;
    this.emergencyInformation = emergencyInfo;
  }

  @override
  _MfrInformationState createState() => _MfrInformationState();
}


class _MfrInformationState extends State<MfrInformation> {
  @override
  Widget build(BuildContext context) {
    // Used to make screen responsive
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

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
        // Displaying a dialog box for confirmation if the card is clicked
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
                      // if the MFR has been chosen to be assigned

                      // function call to update
                      Update();

                      // navigating back to map
                      Navigator.of(context).pop();
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
                      // navigating back to Assign MFR screen
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
    // getting document reference to pending and ongoing emergencies
    DocumentReference document1 = Firestore.instance.collection("PendingEmergencies").document(widget.emergencyInformation.patientRollNo);
    DocumentReference document2 = Firestore.instance.collection("OngoingEmergencies").document(widget.emergencyInformation.patientRollNo);

    // creating a map object - needed for making ongoing emergencies
    Map map = new Map();

    // assigning values to the map object
    map['contact'] = widget.contact;
    map['name'] = widget.name;

    // running transaction - so that either both of these transactions take place or neither of them do
    Firestore.instance.runTransaction((transaction) async {
      // transaction 1 - deleting the emergency from the pending emergencies collection
      await transaction
          .delete(document1)
          .catchError((e) {})
          .whenComplete(() {});

      // transaction 2 - adding the emergency to the ongoing emergencies collection
      await transaction
          .set(document2 ,{
            'genderPreference' : widget.emergencyInformation.genderPreference,
              'location' : widget.emergencyInformation.location,
              'mfr' : widget.rollNo,
              'mfrDetails' : map,
              'patientContactNo' : widget.emergencyInformation.patientContactNo,
              'patientRollNo' : widget.emergencyInformation.patientRollNo,
              'reportingTime' : widget.emergencyInformation.reportingTime,
              'severity' : widget.emergencyInformation.severity
          })
          .catchError((e) {})
          .whenComplete(() {});


    }).catchError((e) {
      throw(e);
    });
  }

}
