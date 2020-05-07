
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/pages/MFR_home.dart';
import 'package:provider/provider.dart';
import 'package:ems_direct/models/emergency_models.dart';
import 'package:ems_direct/pages/MapMFR.dart';

//global variables to help maintain record of what alerts have been already shown
GlobalKey<_AlertFunctionMfrState> mfrAlertFunctionGlobalKey = GlobalKey();
List<String> alertBuffer = [];
List<String> alertBufferOngoing = [];

//This is responsible for alerting MFRs of any pending emergencies with a severity level of low/medium
class AlertFunctionMfr extends StatefulWidget {
  var _userData;
  Key key;

  AlertFunctionMfr(var userData, Key passedkey) {
    _userData = userData;
    key = passedkey;
  }

  @override
  _AlertFunctionMfrState createState() => _AlertFunctionMfrState(_userData);
}

class _AlertFunctionMfrState extends State<AlertFunctionMfr> {
  var _userData;

  _AlertFunctionMfrState(var userData) {
    _userData = userData;
    //print("--------------got ${_userData.data}");
  }

  var databaseReference = Firestore.instance;
  var _isAvailable;
  var _isOccupied;
  var _gender;
  var genderToBeIgnored;
  var locationOfEmergency;
  var studentContactNo;
  var patientRollNumber;

  void getInitialData(var docId) async {
    try {
      await databaseReference
          .collection("Mfr")
          .document(docId)
          .get()
          .then((onVal) {
        setState(() {
          _isOccupied = onVal.data['isOccupied'];
          _isAvailable = onVal.data['isActive'];
          _gender = onVal.data['gender'];
        });
      }).then((_) {
        print('Initial data recieved');
      }).catchError((onError) {
        print(onError.message);
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  //updates field values after rejection
  Future updateDecline(var docID) async {
    DocumentReference docRef =
        databaseReference.collection("PendingEmergencies").document(docID);
    try {
      DocumentSnapshot doc = await docRef.get();
      await docRef.updateData({
        'declinedBy': FieldValue.arrayUnion([widget._userData['rollNo']]),
        'declines': doc.data['declines'] + 1,
      });
    } catch (e) {
      print("updated decline info");
      throw (e);
    }
  }

  //sets the local occupied variable to control for alerts
  void updateOccupiedLocal(bool val) {
    setState(() {
      _isOccupied = val;
    });
  }

  //accept: delete the pending record, create the ongoing record
  //update status of occupied in both the database and the current thing
  Future acceptTransaction(
      var docId,
      var location,
      var genderPreference,
      var patientRollNo,
      var time,
      var severityLevel,
      var patientContactNo,
      bool newVal) async {
    //have a reference to the pending document
    DocumentReference pendingRef =
        databaseReference.collection("PendingEmergencies").document(docId);
    //have a reference to the ongoing document
    DocumentReference ongoingRef =
        databaseReference.collection("OngoingEmergencies").document(docId);
    //have a reference for the mfr document
    DocumentReference mfrRef = databaseReference
        .collection("Mfr")
        .document(widget._userData['rollNo']);

    try {
      await databaseReference.runTransaction((Transaction tx) async {
        dynamic snapshot = await ongoingRef.get();
        //print("--------------------------------------------------------------${snapshot.data}");
        if (snapshot.data != null &&
            snapshot.data['mfr'] != widget._userData['rollNo']) {
          throw ("Cannot create emergency has already been accepted");
        }
        await tx.set(ongoingRef, {
          'mfr': widget._userData['rollNo'],
          'mfrDetails': {
            'name': widget._userData['name'],
            'contact': widget._userData['contact'],
          },
          'location': location,
          'genderPreference': genderPreference,
          'patientRollNo': patientRollNo,
          'reportingTime': time,
          'severity': severityLevel,
          'patientContactNo': patientContactNo,
        });
        await tx.delete(pendingRef);
        updateOccupiedLocal(true);
        mfrHomeGlobalKey.currentState.updateOccupied(true);
        studentContactNo = patientContactNo;
        locationOfEmergency = location;
        patientRollNumber = patientRollNo;
      });
    } catch (e) {
      throw (e);
    }
  }

  //function to show a pendingEmergency alert
  void showPendingAlert(var doc, var width, var height) async {
    //only shows alerts if there is a pending emergency document AND if MFR is available+not occupied
    //-------------- TESTING ------------------------------------
    //print('ID: ${doc[0].patientRollNo}');
    //-----------------------------------------------------------

    alertBuffer.add(doc[0].patientRollNo);
    bool manuallyClosed = false;

    //setting the 30 second timer for the dialog
    Future.delayed(Duration(seconds: 30)).then((_) {
      if (!manuallyClosed) {
        Navigator.of(context).pop();
      }
    });

    showDialog(
      context: context,
      builder: (context) {
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
                  manuallyClosed = true;
                  Navigator.of(context).pop();
                  try {
                    await acceptTransaction(
                        doc[0].patientRollNo,
                        doc[0].location,
                        doc[0].genderPreference,
                        doc[0].patientRollNo,
                        doc[0].reportingTime,
                        doc[0].severity,
                        doc[0].patientContactNo,
                        true);
                  } catch (e) {
                    print("Transaction failed -------------> $e");
                  }
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
                  manuallyClosed = true;
                  Navigator.of(context).pop();
                  try {
                    await updateDecline(doc[0].patientRollNo);
                    updateOccupiedLocal(false);
                    mfrHomeGlobalKey.currentState.updateOccupied(false);
                  } catch (e) {
                    print(e.toString());
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void showOngoingAlert(var doc, var width, var height) async {
    //only shows alerts if there is a pending emergency document AND if MFR is available+not occupied
    //-------------- TESTING ------------------------------------
    // print(widget.occupied);
    //print(doc.data);
    //print('ID: ${doc[0].patientRollNo}');
    //-----------------------------------------------------------

    alertBufferOngoing.add(doc[0].patientRollNo);
    bool manuallyClosed = false;

    setState(() {
      updateOccupiedLocal(true);
      mfrHomeGlobalKey.currentState.updateOccupied(true);
    });

    //setting the timer for the dialog
    Future.delayed(Duration(seconds: 30)).then((_) {
      if (!manuallyClosed) {
        Navigator.of(context).pop();
      }
    });

    showDialog(
      context: context,
      builder: (context) {
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
                    manuallyClosed = true;
                    Navigator.of(context).pop();
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
                    print('go to map');
                    manuallyClosed = true;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MapMFR(
                                locationOfEmergency,
                                studentContactNo,
                                _userData['rollNo'],
                                patientRollNumber)));
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void updateStatus(bool available, bool occupied) {
    setState(() {
      _isOccupied = occupied;
      _isAvailable = available;
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
    print('IN THIS FUNCTION');
    //getting screen size information
    var screenSize = MediaQuery.of(context).size;
    var _width = screenSize.width;
    var _height = screenSize.height;
    //setting providers to listen to collections
    var _pendingEmergencyList =
        Provider.of<List<PendingEmergencyModel>>(context);
    var _ongoingEmergencyList =
        Provider.of<List<OngoingEmergencyModel>>(context);
    int numPending = 0;
    int numOngoing = 0;

    //print(_ongoingEmergencyList);
    //print(_pendingEmergencyList);
    //print(_gender);
    //print(genderToBeIgnored);
    //print(_isOccupied);
    //print(_isAvailable);

    //handling cases for null values (this can happen in the case of null data being received from the stream)
    if (_pendingEmergencyList != null &&
        _gender != null &&
        _pendingEmergencyList.length > 0) {
      //filtering the pending emergency to make sure MFR does not get alerts for the emergencies he/she ignored
      _pendingEmergencyList.removeWhere((item) {
        int num = item.declines;
        return num >= 4;
      });
      //filtering the pending emergency to make sure MFR does not get alerts for the emergencies he/she rejected
      if (_pendingEmergencyList.length > 0) {
        _pendingEmergencyList.removeWhere(
            (item) => item.declinedBy.contains(widget._userData['rollNo']));
      }
      //putting another filter of gender only if the list is not empty
      if (_pendingEmergencyList.length > 0) {
        if (_gender == 'M') {
          genderToBeIgnored = 'F';
        } else
          genderToBeIgnored = 'M';
        _pendingEmergencyList.removeWhere(
            (item) => item.genderPreference.contains(genderToBeIgnored));
      }
      numPending = _pendingEmergencyList.length;
    }

    if (_pendingEmergencyList != null) {
      //if there is some roll number that the alerted buffer contains but the pending does not
      //remove that string from the alerted buffer
      var toRemove = [];
      //print("alertbuffer: $alertBuffer");
      if (_pendingEmergencyList.length > 0) {
        alertBuffer.forEach((rollNumber) {
          if (!(_pendingEmergencyList.map(
              (emergency) => (emergency.patientRollNo))).contains(rollNumber)) {
            toRemove.add(rollNumber);
          }
        });
        alertBuffer.removeWhere((item) => toRemove.contains(item));
      } else {
        alertBuffer = [];
      }
      //print("alertbuffer: $alertBuffer");
    }

    //handling cases for null values (this can happen in the case of null data being received from the stream)
    if (_ongoingEmergencyList != null && _ongoingEmergencyList.length > 0) {
      //filtering for any emergency that is in MFRs name
      _ongoingEmergencyList
          .retainWhere((item) => item.mfr.contains(widget._userData['rollNo']));
      numOngoing = _ongoingEmergencyList.length;
      if (_ongoingEmergencyList.length > 0) {
        locationOfEmergency = _ongoingEmergencyList[0].location;
        studentContactNo = _ongoingEmergencyList[0].patientContactNo;
        patientRollNumber = _ongoingEmergencyList[0].patientRollNo;
      }
    }

    if (_ongoingEmergencyList != null) {
      var toRemove = [];
      //print("alertbufferOngoing: $alertBufferOngoing");
      if (_ongoingEmergencyList.length > 0) {
        alertBufferOngoing.forEach((rollNumber) {
          if (!(_ongoingEmergencyList.map(
              (emergency) => (emergency.patientRollNo))).contains(rollNumber)) {
            toRemove.add(rollNumber);
          }
        });
        alertBufferOngoing.removeWhere((item) => toRemove.contains(item));
      } else {
        alertBufferOngoing = [];
      }
      //print("alertbufferOngoing: $alertBufferOngoing");
    }

    //this is where the two alert functions are called depending on whether there is data AND conditions are met
    if (_isAvailable != null && _isOccupied != null) {
//      //if available, need to check if ongoing emergency is there
      if (_isAvailable && !_isOccupied) {
        //check if there is an ongoing emergency
        if (_ongoingEmergencyList != null && numOngoing > 0) {
          //call the send ongoingEmergency alert function
          if (!alertBufferOngoing
              .contains(_ongoingEmergencyList[0].patientRollNo)) {
            WidgetsBinding.instance.addPostFrameCallback((_) =>
                showOngoingAlert(_ongoingEmergencyList, _width, _height));
          }
        }
        //if there is no ongoing emergency then check if the person is ready to receive pending alert
        else if (_pendingEmergencyList != null && numPending > 0) {
          //call the send pendingEmergency alert function
          if (!alertBuffer.contains(_pendingEmergencyList[0].patientRollNo)) {
            WidgetsBinding.instance.addPostFrameCallback((_) =>
                showPendingAlert(_pendingEmergencyList, _width, _height));
          }
        }
      }
    }
    return Container();
  }
}
