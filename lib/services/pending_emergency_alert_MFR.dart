import 'package:ems_direct/services/auth.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:ems_direct/pages/MFR_home.dart';
import 'package:provider/provider.dart';

//This is responsible for alerting MFRs of any pending emergencies with a severity level of low/medium
class AlertFunctionMfr extends StatefulWidget {
//  var availability;
//  var occupied;
//  var mfrRollNo;
  var _userData;

  //the alert is received on the MFRs screens depending on the three variables below
  //decision: only show alert if the MFR is available, there is a pending emergency document and that document is to be rendered
  AlertFunctionMfr(var userData) {
    _userData = userData;
  }

  @override
  _AlertFunctionMfrState createState() => _AlertFunctionMfrState(_userData);
}

class _AlertFunctionMfrState extends State<AlertFunctionMfr> {
  var _userData;

  _AlertFunctionMfrState(var userData) {
    _userData = userData;

    print("--------------got ${_userData.data}");
  }
  var databaseReference = Firestore.instance;
  var _isAvailable;
  var _isOccupied;

  var futures = List<Future>();

  void getInitialData(var docId) {
    try {
      databaseReference.collection("Mfr").document(docId).get().then((onVal) {
        setState(() {
          _isOccupied = onVal.data['isOccupied'];
          _isAvailable = onVal.data['isActive'];
          print('done!');
        });
      }).catchError((onError) {
        print(onError.message);
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

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
    DocumentReference docRef = databaseReference
        .collection('Mfr')
        .document(widget._userData['rollNo']);
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
  Future updateDeclineCount(var docID) async {
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

  //updates declinedBy of emergency
  Future updateDeclineBy(var docID) async {
    DocumentReference docRef =
        databaseReference.collection("PendingEmergencies").document(docID);
    return await databaseReference.runTransaction((Transaction tx) async {
      DocumentSnapshot docSnapshot = await tx.get(docRef);
      if (docSnapshot.exists) {
        await tx.update(docRef, <String, dynamic>{
          'declinedBy': FieldValue.arrayUnion([
            widget._userData['rollNo']
          ]) //docSnapshot.data['declinedBy'].add(widget.mfrRollNo)
        });
      }
    }).then((_) {
      print("declinedBy updated");
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
      'mfr': widget._userData['rollNo'],
      'location': location,
      'genderPreference': genderPreference,
      'patientRollNo': patientRollNo,
      'reporting_time': FieldValue.serverTimestamp(),
      'severity': severityLevel,
    });
  }

  //main function to show alert
  Future showAlert(var num, DocumentSnapshot doc, var width, var height) async {
    num = 1; //FOR TESTING ALERTS BASED ON SITUATIONS WITH A NULL STREAM
    //_isOccupied = true;

    if (_isAvailable && num > 0 && !_isOccupied) {
      //-------------- TESTING ------------------------------------
      // print(widget.occupied);
      //print(doc.data);
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
                  createOngoingEmergencyDocument(
                      doc.data['location'],
                      doc.data['genderPreference'],
                      doc.data['patientRollNo'],
                      doc.data['severity']);
                  deleteRecord(doc.documentID);
                  updateOccupiedStatus(true, doc.documentID);
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
                onPressed: () async {
                  print('no');
                  Navigator.of(context).pop();
                  //await updateDeclineCount(doc.documentID);
                  //await updateDeclineBy(doc.documentID);
                  return rejectCalls(doc.documentID);
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  Future rejectCalls(var docID) async {
    var futures = List<Future>();
    futures.add(updateDeclineBy(docID));
    futures.add(updateDeclineBy(docID));

    await Future.wait(futures);
    print('Reject calls done!');
  }

  Future completeFutures() async {
    return await Future.wait(futures);
  }

  void printData(var docs) {
    if (docs != null)
      for (int i = 0; i < docs.length; i++) {
        print(docs[i].data);
      }
  }

  @override
  void initState() {
    super.initState();
    //State management for keepsignedin
    //WidgetsBinding.instance.addObserver(this);
    //initializing stream to null as MFR will always be unavailable unless made available by himself
    //_documentStream = null;

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => getInitialData(widget._userData['rollNo']));
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var _width = screenSize.width;
    var _height = screenSize.height;
    var _docs = Provider.of<QuerySnapshot>(context);
    var num = 0;
    print('IN THIS FUNCTION');

    if (_docs != null) {
      List<DocumentSnapshot> _docList = _docs.documents;
      if (_docs.documents[0].data != null) {
        //List<DocumentSnapshot> filtered =
        _docList.removeWhere((item) =>
            item.data['declinedBy'].contains(widget._userData['rollNo']));
        num = _docList.length;
        print(num);
      }

      //Calls the show alert function after build is complete to avoid repeated alerts
      if (_isAvailable != null || _isOccupied != null) {
        if ((_isAvailable) && (_docs != null) && (num > 0) && (!_isOccupied)) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => printData(_docList));
          WidgetsBinding.instance.addPostFrameCallback((_) async =>
              await showAlert(
                  _docs.documents.length, _docList[0], _width, _height));
        }
      }
    }

    Future.delayed(Duration(seconds: 3));

    //return Container();

    return FutureBuilder(
        future: completeFutures(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return
          } else {
            return Container(
              child: SpinKitPulse(
                color: Colors.white,
                size: 50,
              ),
            );
          }
        });
  }
}
