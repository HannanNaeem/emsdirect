//import 'dart:html';

import 'package:ems_direct/services/auth.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:ems_direct/pages/MFR_home.dart';

//This is responsible for alerting MFRs of any pending emergencies with a severity level of low/medium
class AlertFunction extends StatefulWidget {
  var availability;
  var length;
  var render;
  var documentSnapshot;
  Function(bool) callback;

  //the alert is received on the MFRs screens depending on the three variables below
  //decision: only show alert if the MFR is available, there is a pending emergency document and that document is to be rendered
  AlertFunction(
      {this.availability,
      this.length,
      this.render,
      this.documentSnapshot,
      this.callback});
  @override
  _AlertFunctionState createState() => _AlertFunctionState();
}

class _AlertFunctionState extends State<AlertFunction> {
  var databaseReference = Firestore.instance;

  //deletes the given docID document
  void deleteRecord(var docID) {
    try {
      Firestore.instance
          .collection('PendingEmergencies')
          .document(docID)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  //updates decline count of MFR
  void updateDeclineCount(docID) async {
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

  void createOngoingEmergencyDocument(
      String mfrName, String contactNo, String severityLevel) async {
    await databaseReference
        .collection("PendingEmergencies")
        .document()
        .setData({
      'mfrName': mfrName,
      'contact': contactNo,
      'reporting_time': FieldValue.serverTimestamp(),
      'severity': severityLevel,
    });
  }

  //main function to show alert
  void showAlert(bool available, int num, bool render, DocumentSnapshot doc,
      var width, var height) {
    num = 1; //FOR TESTING ALERTS BASED ON SITUATIONS WITH A NULL STREAM
    if (available == true && num > 0 && render) {
      //-------------- TESTING ------------------------------------
      print(render);
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
                  //TODO: add real name and contact here
                  createOngoingEmergencyDocument(
                      "Name", "contactNo", doc.data['severity']);
                  deleteRecord(doc.documentID);
                  //returns true to make sure MFR does not receive more alerts
                  widget.callback(true);
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
                  widget.callback(false);
                  updateDeclineCount(doc.documentID);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  //UNSURE OF THIS
  @override
  void dispose() {
    print('widget disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    print('IN THIS FUNCTION');

    //Calls the show alert function after build is complete to avoid repeated alerts
    WidgetsBinding.instance.addPostFrameCallback((_) => showAlert(
        widget.availability,
        widget.length,
        widget.render,
        widget.documentSnapshot,
        width,
        height));
    return Container(key: UniqueKey());
  }
}
