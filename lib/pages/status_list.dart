import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:ems_direct/models/emergency_models.dart';
import 'package:ems_direct/pages/student_home.dart';


class DisplayList extends StatefulWidget {

  bool _keepSignedIn;
  var _userData;
  DisplayList(bool keepSignedIn,var userData){
    _keepSignedIn = keepSignedIn;
    _userData = userData;
  }

  @override
  _DisplayListState createState() => _DisplayListState(_keepSignedIn, _userData);
}

class _DisplayListState extends State<DisplayList> {

  var _keepSignedIn;
  var _userData;
  _DisplayListState(bool keepSignedIn, var userData){
    _keepSignedIn = keepSignedIn;
    _userData = userData;
  }

  final databaseReference = Firestore.instance;
  String stringMfrDetails;

  @override
    Widget build(BuildContext context) {

      String _status = 'Loading';

      var pendingEmergency = Provider.of<List<PendingEmergencyModel>>(context);
      var onGoingEmergency = Provider.of<List<OngoingEmergencyModel>>(context);
      try{
        if(onGoingEmergency.length == 1 && onGoingEmergency != null){
            _status = "onGoing";
          }
        else if(pendingEmergency.length == 1 && pendingEmergency != null){
          _status = "pending";
        }
        else{
          _status = "ended";

          //at the end of emergency, go back to home screen
          Timer(
            Duration(seconds: 2),
              () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder : (BuildContext context) {

                        return StudentHome(_keepSignedIn, _userData);
                      }
                  )
              )
          );
        }
      }catch(e){
        print(e);
      }

      return Container(
        color: Colors.red[400],
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment(-1,-1),
              child: SpinKitRipple(
                color: Colors.red[200],
                size: 80.0,
              ),
            ),
            Align(
              alignment: Alignment(0,0.1),
              child:getWidget(_status),
            )
          ],
        )
      );
  }
}

//class getDetails(var userData){
//    databaseReference
//        .collection('OngoingEmergencies')
//        .where('patientRollNo', isEqualTo: userData.data['rollNo'])
//        .getDocuments().then((QuerySnapshot snapshot){
//    if(snapshot.documents.isNotEmpty){
//    mfrDetails = (snapshot.documents[0].data['mfrDetails']);
//    print(snapshot.documents[0].data['mfrDetails']);
//    }
//    });
//}

//class MfrDetails{
//  details(String rollNo){
//    return Firestore.instance
//        .collection('OngoingEmergencies')
//        .where('patientRollNo', isEqualTo: rollNo)
//        .getDocuments();
//  }
//}

String getDetails(var userData){
  String mfr = 'None';
  Firestore.instance.collection('OngoingEmergencies')
  .where('patientRollNo', isEqualTo: userData.data['rollNo'])
  .getDocuments().then((QuerySnapshot snapshot){
    if(snapshot.documents.isNotEmpty){
      mfr = snapshot.documents[0].data['mfrDetails'];
    }
  });
  return mfr;
}

String getText(String status, var userData){
  if(status == 'onGoing'){
    getDetails(userData);
    return 'wut';
  }
  else if(status == 'pending'){
    return ('Your Emergency request is pedning');
  }
  else if(status == 'loading'){
    return ('Loading...');
  }
  else{
    return ('Your Emergency Ended');
  }
}

Widget getWidget(String status){
  if(status == 'onGoing'){
    return Text(
      'masley aa rhayy',
      style: TextStyle(
        fontSize: 20.0,
        fontFamily: 'HelveticaNeueLight',
        color: Colors.black,
        letterSpacing: 2.0,
      ),
    );
  }
  else if(status == 'pending'){
    return Text(
      'Emergency Request is Pending',
      style: TextStyle(
        fontSize: 20.0,
        fontFamily: 'HelveticaNeueLight',
        color: Colors.black,
        letterSpacing: 2.0,
      ),
    );
  }
  else if(status == 'loading'){
    return Text(
      'loading',
      style: TextStyle(
        fontSize: 20.0,
        fontFamily: 'HelveticaNeueLight',
        color: Colors.black,
        letterSpacing: 2.0,
      ),
    );
  }
  else{
    return Text(
      'Your emergency ended',
      style: TextStyle(
        fontSize: 20.0,
        fontFamily: 'HelveticaNeueLight',
        color: Colors.black,
        letterSpacing: 2.0,
      ),
    );
  }
}