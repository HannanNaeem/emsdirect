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
//  var availability;
//  var occupied;
//  var gender;

//  AlertFunctionMfr(var available, var occupied, var userData, var gender) {
//    _userData = userData;
//    availability = available;
//    occupied = occupied;
//    gender = gender;
//  }

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
  Future updateOccupiedStatus(bool newVal, var docID) async {
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
      String patientContactNo) async {
    return await databaseReference
        .collection('OngoingEmergencies')
        .document(patientRollNo)
        .setData({
      'mfr': widget._userData['rollNo'],
      'location': location,
      'genderPreference': genderPreference,
      'patientRollNo': patientRollNo,
      'reportingTime': FieldValue.serverTimestamp(),
      'severity': severityLevel,
      'patientContactNo': patientContactNo,
    });
  }

  //main function to show alert
  Future showAlert(int num, var doc, var width, var height) async {
    //------------TESTING---------------------
    //num = 1; //FOR TESTING ALERTS BASED ON SITUATIONS WITH A NULL STREAM
//    _isOccupied = false;
//    _isAvailable = true;
//    var doc = {
//      'declines': 0,
//      'severity': 'low',
//      'genderPreference': 'F',
//      'patientRollNo': '21100118',
//      'declinedBY': [''],
//      'location': null
//    };
    //-----------------------------------------

    //only shows alerts if there is a pending emergency document AND if MFR is available+not occupied
    if (_isAvailable && (num > 0) && !_isOccupied) {
      //-------------- TESTING ------------------------------------
      // print(widget.occupied);
      //print(doc.data);
      //print('ID: ${doc.documentID}');
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
              fontSize: 24,
            ),
          ),
          content: Stack(
            children: <Widget>[
              Text(
                "Severity level:${doc.severity}\n Patient: ${doc.patientRollNo}\n Contact: ${doc.patientContactNo}",
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
                  //mfrGlobalKey.currentState.locationOfEmergency = doc.location;
                  //mfrGlobalKey.currentState.patientContactNo = doc.patientContactNo;
                  _isOccupied = true;
                  await createOngoingEmergencyDocument(
                      doc.location,
                      doc.genderPreference,
                      doc.patientRollNo,
                      doc.severity,
                      doc.patientContactNo);
                  await deleteRecord(doc.patientRollNo);
                  Navigator.of(context).pop();
                  return await updateOccupiedStatus(true, doc.patientRollNo);
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
                  return await updateDecline(doc.patientRollNo);
                },
              ),
            ),
          ],
        ),
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
//    _isAvailable = widget.availability;
//    _isOccupied = widget.occupied;
//    _gender = widget.gender;
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
//    print(_height);
//    print(_width);
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
      _pendingEmergencyList.removeWhere(
          (item) => item.declinedBy.contains(widget._userData['rollNo']));
      if (_pendingEmergencyList != null)
        _pendingEmergencyList
            .retainWhere((item) => item.genderPreference.contains(_gender));
      numPending = _pendingEmergencyList.length;
      WidgetsBinding.instance
          .addPostFrameCallback((_) => printData(_pendingEmergencyList));
    }

    if (_ongoingEmergencyList != null) {
      printData((_ongoingEmergencyList));
      _ongoingEmergencyList
          .retainWhere((item) => item.mfr.contains(widget._userData['rollNo']));
      numOngoing = _ongoingEmergencyList.length;
      print('huh $numOngoing');
      WidgetsBinding.instance
          .addPostFrameCallback((_) => printData(_ongoingEmergencyList));
    }

    if (_isAvailable != null && _isOccupied != null) {
      print('wut');
      if (!_isOccupied && _isAvailable) {
        print('hmm');
        if (_ongoingEmergencyList != null && numOngoing > 0) {
          print('uhh wut');
          WidgetsBinding.instance.addPostFrameCallback((_) async =>
              await showAlert(
                  numOngoing, _ongoingEmergencyList[0], _width, _height));
        } else if (_pendingEmergencyList != null && numPending > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) async =>
              await showAlert(
                  numPending, _pendingEmergencyList[0], _width, _height));
        }
      }
    }

//    //handling cases for null values (this can happen in the case of null data being received from the stream)
//    if (_docs != null && _isAvailable != null && _isOccupied != null) {
//      //getting the document list from the snapshot for the purpose of further filtering
//      List<DocumentSnapshot> _docList = _docs.documents;
//      //making sure the alerts received are those which are not already declined by the MFR
//      //if (_docs.documents[0].data != null) {
//      //handling the null value error
//      _docList.removeWhere((item) =>
//          item.data['declinedBy'].contains(widget._userData['rollNo']));
//      _docList.retainWhere(
//          (item) => item.data['genderPreference'].contains(_gender));
//      num = _docList.length;
//      print(num);
//      //}
//      //only call the show alert function if the MFR is available, not occupied and actually has emergencies to tend to
//      if ((_isAvailable) && (_docs != null) && (num > 0) && (!_isOccupied)) {
//        WidgetsBinding.instance
//            .addPostFrameCallback((_) => printData(_docList));
//        WidgetsBinding.instance.addPostFrameCallback((_) async =>
//            await showAlert(
//                _docs.documents.length, _docList[0], _width, _height));
//      }
//
////      if (_isAvailable != null && _isOccupied != null) {
////        if ((_isAvailable) && (_docs != null) && (num > 0) && (!_isOccupied)) {
////          WidgetsBinding.instance.addPostFrameCallback((_) => printData(_docList));
////          WidgetsBinding.instance.addPostFrameCallback((_) async => await showAlert(_docs.documents.length, _docList[0], _width, _height));
////        }
//    }

    return Container();
  }
}
