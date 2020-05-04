import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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


  @override
    Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

      String _status = 'pending';
      String mfrName = '';
      String mfrContact = '';
      sleep(Duration(seconds:1));

      var pendingEmergency = Provider.of<List<PendingEmergencyModel>>(context);
      var onGoingEmergency = Provider.of<List<OngoingEmergencyModel>>(context);
      try{
        if(onGoingEmergency.length == 1 && onGoingEmergency != null){
            _status = "onGoing";
            mfrName = (onGoingEmergency[0].mfrDetails['name']).toString();
            mfrContact = (onGoingEmergency[0].mfrDetails['contact']).toString();
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
        color:const Color(0xff840123),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SpinKitRipple(
              color: Colors.red[200],
              size: 120.0,
            ),
            SizedBox(height: height*0.03),
            getWidget(_status, mfrName, mfrContact,height,width),
          ],
        )
      );
  }
}


Widget getWidget(String status, String mfrName, String mfrContact, var height, var width){
  String answer;
  if(status == 'onGoing'){
    answer = 'MFR has been assigned to your emergency';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            answer,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'HelveticaNeueLight',
              color: Colors.white,
              letterSpacing: 2.0,
            ),
          ),
        ),
        Container(
          constraints: BoxConstraints(maxWidth: width*0.80, maxHeight: height*0.15),
          child: Card(
            elevation: 8,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Name:',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                    Text(
                      '$mfrName',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'HelveticaNeueLight',
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Contact:',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                    Text(
                      '$mfrContact',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'HelveticaNeueLight',
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
  else if(status == 'pending'){
    answer = 'Your Emergency request is pending';
  }
  else{
    answer = 'Your Emergency has ended';
  }
  return Text(
    answer,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 20.0,
      fontFamily: 'HelveticaNeueLight',
      color: Colors.white,
      letterSpacing: 2.0,
    ),
  );
}