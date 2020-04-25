import 'package:ems_direct/services/auth.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:ems_direct/pages/MFR_home.dart';
import 'package:provider/provider.dart';

//This is responsible for alerting MFRs of any pending emergencies with a severity level of low/medium
class AlertFunction extends StatefulWidget {
  var availability;
  var occupied;
  var mfrRollNo;

  //the alert is received on the MFRs screens depending on the three variables below
  //decision: only show alert if the MFR is available, there is a pending emergency document and that document is to be rendered
  AlertFunction({this.availability, this.occupied, this.mfrRollNo});
  @override
  _AlertFunctionState createState() => _AlertFunctionState();
}

class _AlertFunctionState extends State<AlertFunction> {
  var databaseReference = Firestore.instance;

  //deletes the given docID document
  void deleteRecord(var docID) async {
    try {
      await Firestore.instance
          .collection('PendingEmergencies')
          .document(docID)
          .delete()
          .then((_) {
        print('record deleted');
      }).catchError((onError) {
        print(onError.message);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  //updates occupied status of MFR
  void updateOccupiedStatus(bool newVal, var docID) async {
    DocumentReference docRef =
        databaseReference.collection('Mfr').document(widget.mfrRollNo);
    await databaseReference.runTransaction((Transaction tx) async {
      DocumentSnapshot docSnapshot = await tx.get(docRef);
      if (docSnapshot.exists) {
        await tx.update(docRef, <String, dynamic>{'isOccupied': newVal});
      }
    }).then((_) {
      print("Occupied status updated");
    }).catchError((onError) {
      print(onError.message);
    });
  }

  //updates decline count of emergency
  void updateDeclineCount(var docID) async {
    DocumentReference docRef =
        databaseReference.collection("PendingEmergencies").document(docID);
    await databaseReference.runTransaction((Transaction tx) async {
      DocumentSnapshot docSnapshot = await tx.get(docRef);
      if (docSnapshot.exists) {
        await tx.update(docRef,
            <String, dynamic>{'declines': docSnapshot.data['declines'] + 1});
      }
    }).then((_) {
      print("Decline count incremented");
    }).catchError((onError) {
      print(onError.message);
    });
  }

  //MFR roll number, emergency location, genderpreference, patientrollnumber, reported time, severity
  void createOngoingEmergencyDocument(
      GeoPoint location,
      String genderPreference,
      String patientRollNo,
      String severityLevel) async {
    await databaseReference
        .collection('OngoingEmergencies')
        .document(patientRollNo)
        .setData({
      'mfr': widget.mfrRollNo,
      'location': location,
      'genderPreference': genderPreference,
      'patientRollNo': patientRollNo,
      'reporting_time': FieldValue.serverTimestamp(),
      'severity': severityLevel,
    });
  }

  //main function to show alert
  void showAlert(int num, DocumentSnapshot doc, var width, var height) {
    num = 1; //FOR TESTING ALERTS BASED ON SITUATIONS WITH A NULL STREAM
    widget.occupied = false;
    if (widget.availability == true && num > 0 && !widget.occupied) {
      //-------------- TESTING ------------------------------------
      print(widget.occupied);
      print(doc.data);
      print('ID: ${doc.documentID}');
      //-----------------------------------------------------------

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            "New Emergency!!",
            style: TextStyle(
              fontFamily: 'HelveticaNeueLight',
              letterSpacing: 2.0,
              fontSize: 20,
            ),
          ),
          content: Text(
            "Severity level: ${doc.data['severity']}",
            style: TextStyle(
              fontFamily: 'HelveticaNeueLight',
              letterSpacing: 2.0,
              fontSize: 18,
              //color: Colors.grey[600],
            ),
          ),
          actions: <Widget>[
            Padding(
              //alignment: Alignment.bottomLeft,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: FlatButton(
                child: Text(
                  'ACCEPT',
                  style: TextStyle(
                    fontFamily: 'HelveticaNeueLight',
                    //fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontSize: 20,
                    color: const Color(0xff1a832a),
                  ),
                ),
                onPressed: () {
                  print('yes');
//                  createOngoingEmergencyDocument(
//                      doc.data['location'],
//                      doc.data['genderPreference'],
//                      doc.data['patientRollNo'],
//                      doc.data['severity']);
//                  deleteRecord(doc.documentID);
//                  updateOccupiedStatus(true, doc.documentID);
                  Navigator.of(context).pop();
                },
              ),
            ),
            SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: FlatButton(
                child: Text(
                  'REJECT',
                  style: TextStyle(
                    fontFamily: 'HelveticaNeueLight',
                    letterSpacing: 2,
                    fontSize: 20,
                    color: const Color(0xffee0000),
                  ),
                ),
                onPressed: () {
                  print('no');
                  //updateDeclineCount(doc.documentID);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  void printData(var docs) {
    if (docs != null)
      for (int i = 0; i < docs.documents.length; i++) {
        print(docs.documents[i].data['declinedBy'][0]);
      }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    var docs = Provider.of<QuerySnapshot>(context);
    print('IN THIS FUNCTION');

    //Calls the show alert function after build is complete to avoid repeated alerts
    if (widget.availability)
      WidgetsBinding.instance.addPostFrameCallback((_) => printData(docs));
    if (widget.availability && docs != null)
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          showAlert(docs.documents.length, docs.documents[0], width, height));

    return Container();
  }
}
