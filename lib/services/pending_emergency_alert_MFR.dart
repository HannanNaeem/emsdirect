import 'package:ems_direct/services/auth.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:ems_direct/pages/MFR_home.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ems_direct/models/emergency_models.dart';

//This is responsible for alerting MFRs of any pending emergencies with a severity level of low/medium
class AlertFunctionMfr extends StatefulWidget {
  var _userData;

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
  var _gender;

  void getInitialData(var docId) {
    try {
      databaseReference.collection("Mfr").document(docId).get().then((onVal) {
        setState(() {
          _isOccupied = onVal.data['isOccupied'];
          _isAvailable = onVal.data['isActive'];
          _gender = onVal.data['gender'];
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
  Future deleteRecord(var docID) async {
    try {
      return await Firestore.instance
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
  Future updateOccupiedStatus(bool newVal) async {
    DocumentReference docRef = databaseReference
        .collection('Mfr')
        .document(widget._userData['rollNo']);
    return await databaseReference.runTransaction((Transaction tx) async {
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

  //updates field values after rejection
  Future updateDecline(var docID) async {
    DocumentReference docRef =
        databaseReference.collection("PendingEmergencies").document(docID);
    return await databaseReference.runTransaction((Transaction tx) async {
      DocumentSnapshot docSnapshot = await tx.get(docRef);
      if (docSnapshot.exists) {
        await tx.update(docRef, <String, dynamic>{
          'declinedBy': FieldValue.arrayUnion([
            widget._userData['rollNo'],
          ]) //docSnapshot.data['declinedBy'].add(widget.mfrRollNo)
        });
        await tx.update(docRef,
            <String, dynamic>{'declines': docSnapshot.data['declines'] + 1});
      }
    }).then((_) {
      print("declinedBy updated");
    }).catchError((onError) {
      print(onError.message);
    });
  }

  //creates a document in OngoingEmergencies after accpetance of a pending emergency
  Future createOngoingEmergencyDocument(
      GeoPoint location,
      String genderPreference,
      String patientRollNo,
      String severityLevel,
      String patientContactNo,
      Timestamp time) async {
    return await databaseReference
        .collection('OngoingEmergencies')
        .document(patientRollNo)
        .setData({
      'mfr': {
        'name': widget._userData['name'],
        'contact': widget._userData['contact'],
        'rollNo': widget._userData['rollNo']
      },
      'location': location,
      'genderPreference': genderPreference,
      'patientRollNo': patientRollNo,
      'reportingTime': time.toDate(),
      'severity': severityLevel,
      'patientContactNo': patientContactNo,
    });
  }

//  Future updateOnAccept(var doc) async {
//    List<Future> futureList = List<Future>();
//    futureList.add(await createOngoingEmergencyDocument(
//        doc[0].location,
//        doc[0].genderPreference,
//        doc[0].patientRollNo,
//        doc[0].severity,
//        doc[0].patientContactNo));
//    futureList.add(deleteRecord(doc[0].patientRollNo));
//    futureList.add(updateOccupiedStatus(true));
//    for (int i = 1; i < doc.length; i++) {
//      futureList.add(updateDecline(doc[i].patientRollNo));
//    }
//    return Future.wait(futureList);
//  }

  //main function to show alert
  Future showPendingAlert(int num, var doc, var width, var height) async {
    //only shows alerts if there is a pending emergency document AND if MFR is available+not occupied
    if (_isAvailable && (num > 0) && !_isOccupied) {
      //-------------- TESTING ------------------------------------
      // print(widget.occupied);
      //print(doc.data);
      print('ID: ${doc[0].patientRollNo}');
      //-----------------------------------------------------------
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 30), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              "New Emergency!!",
              style: TextStyle(
                fontFamily: 'HelveticaNeueLight',
                letterSpacing: 2.0,
                fontSize: 24,
              ),
            ),
            content: Stack(
              children: <Widget>[
                Text(
                  "Severity level:${doc[0].severity}\nPatient: ${doc[0].patientRollNo}\nContact: ${doc[0].patientContactNo}",
                  style: TextStyle(
                    fontFamily: 'HelveticaNeueLight',
                    letterSpacing: 2.0,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: FlatButton(
                  child: Text(
                    'ACCEPT',
                    style: TextStyle(
                      fontFamily: 'HelveticaNeueLight',
                      letterSpacing: 2.0,
                      fontSize: 20,
                      color: const Color(0xff1a832a),
                    ),
                  ),
                  onPressed: () async {
                    print('yes');
                    _isOccupied = true;
                    Navigator.of(context).pop();
                    await createOngoingEmergencyDocument(
                        doc[0].location,
                        doc[0].genderPreference,
                        doc[0].patientRollNo,
                        doc[0].severity,
                        doc[0].patientContactNo,
                        doc[0].reportingTime);
                    //await deleteRecord(doc[0].patientRollNo);
                    return await updateOccupiedStatus(true);
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
                    _isOccupied = false;
                    Navigator.of(context).pop();
                    return await updateDecline(doc[0].patientRollNo);
                  },
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Future showOngoingAlert(int num, var doc, var width, var height) async {
    //only shows alerts if there is a pending emergency document AND if MFR is available+not occupied
    if (_isAvailable && (num > 0) && !_isOccupied) {
      //-------------- TESTING ------------------------------------
      // print(widget.occupied);
      //print(doc.data);
      //print('ID: ${doc.documentID}');
      //-----------------------------------------------------------
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 30), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              "You have been assigned an emergency!",
              style: TextStyle(
                fontFamily: 'HelveticaNeueLight',
                letterSpacing: 2.0,
                fontSize: 24,
              ),
            ),
            content: Stack(
              children: <Widget>[
                Text(
                  "Severity level:${doc[0].severity}\nPatient: ${doc[0].patientRollNo}\nContact: ${doc[0].patientContactNo}",
                  style: TextStyle(
                    fontFamily: 'HelveticaNeueLight',
                    letterSpacing: 2.0,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: FlatButton(
                    child: Text(
                      'Acknowledge',
                      style: TextStyle(
                        fontFamily: 'HelveticaNeueLight',
                        letterSpacing: 2,
                        fontSize: 20,
                        color: const Color(0xff1a832a),
                      ),
                    ),
                    onPressed: () async {
                      print('acknowledge');
                      _isOccupied = true;
                      Navigator.of(context).pop();
                      return await updateDecline(doc[0].patientRollNo);
                    },
                  ),
                ),
              ),
              Divider(),
              SizedBox(width: 10),
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: FlatButton(
                    child: Text(
                      'Go to map',
                      style: TextStyle(
                        fontFamily: 'HelveticaNeueLight',
                        letterSpacing: 2.0,
                        fontSize: 20,
                        color: const Color(0xff1a832a),
                      ),
                    ),
                    onPressed: () async {
                      print('acknowledge');
                      _isOccupied = true;
                      //delete the below navigator when merging with the map file
                      Navigator.of(context).pop();
                      //Navigator.push<dynamic>(context, MaterialPageRoute(builder: (context) => MapMFR(locationOfEmergency, patientContactNo)));
                      return await updateOccupiedStatus(true);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  //------------TESTING---------------------
  void printData(var docs) {
    docs.forEach((emergency) {
      print(emergency.patientRollNo);
      print(emergency.genderPreference);
    });
  }

  //----------------------------------------

  @override
  void initState() {
    super.initState();
    //getting MFRs data on initialization
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => getInitialData(widget._userData['rollNo']));
  }

  @override
  Widget build(BuildContext context) {
    //getting screen size information
    var screenSize = MediaQuery.of(context).size;
    var _width = screenSize.width;
    var _height = screenSize.height;
    var _pendingEmergencyList =
        Provider.of<List<PendingEmergencyModel>>(context);
    var _ongoingEmergencyList =
        Provider.of<List<OngoingEmergencyModel>>(context);
    int numPending = 0;
    int numOngoing = 0;
    print('IN THIS FUNCTION');
    print(_ongoingEmergencyList);
    print(_gender);
    print(_isOccupied);
    print(_isAvailable);

    //handling cases for null values (this can happen in the case of null data being received from the stream)
    if (_pendingEmergencyList != null && _gender != null) {
      //filtering the pending emergency to make sure MFR does not get alerts for the emergencies he/she rejected
      _pendingEmergencyList.removeWhere(
          (item) => item.declinedBy.contains(widget._userData['rollNo']));
      //putting another filter of gender
      if (_pendingEmergencyList != null)
        _pendingEmergencyList
            .retainWhere((item) => item.genderPreference.contains(_gender));
      numPending = _pendingEmergencyList.length;
      //WidgetsBinding.instance.addPostFrameCallback((_) => printData(_pendingEmergencyList));
    }

    //handling cases for null values (this can happen in the case of null data being received from the stream)
    if (_ongoingEmergencyList != null) {
      //filtering for any emergency that is in my name
      _ongoingEmergencyList
          .retainWhere((item) => item.mfr.contains(widget._userData['rollNo']));
      numOngoing = _ongoingEmergencyList.length;
      //WidgetsBinding.instance.addPostFrameCallback((_) => printData(_ongoingEmergencyList));
    }

    //this is where the two alert functions are called depending on whether there is data AND conditions are met
    if (_isAvailable != null && _isOccupied != null) {
      if (!_isOccupied && _isAvailable) {
        //conditions
        _ongoingEmergencyList = null;
//        if (_ongoingEmergencyList != null && numOngoing > 0) {
//          WidgetsBinding.instance.addPostFrameCallback((_) async =>
//              await showOngoingAlert(
//                  numOngoing, _ongoingEmergencyList[0], _width, _height));
//        } else if (_pendingEmergencyList != null && numPending > 0) {
//          WidgetsBinding.instance.addPostFrameCallback((_) async =>
//              await showPendingAlert(
//                  numPending, _pendingEmergencyList[0], _width, _height));

        _ongoingEmergencyList = null;
        if (_ongoingEmergencyList != null && numOngoing > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) async =>
              await showOngoingAlert(
                  numOngoing, _ongoingEmergencyList, _width, _height));
        } else if (_pendingEmergencyList != null && numPending > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) async =>
              await showPendingAlert(
                  numPending, _pendingEmergencyList, _width, _height));
        }
      }
    }

    return Container();
  }
}
