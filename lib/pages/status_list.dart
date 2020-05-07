import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:ems_direct/models/emergency_models.dart';
import 'package:ems_direct/pages/student_home.dart';
import 'package:url_launcher/url_launcher.dart';

//------------------------------------------------------
// Returns the dynamic widget tree showed on the live status screen 
// The structure is a "top down" list
//------------------------------------------------------


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

      var pendingEmergency = Provider.of<List<PendingEmergencyModel>>(context);
      var onGoingEmergency = Provider.of<List<OngoingEmergencyModel>>(context);
      try{
        if(onGoingEmergency != null &&  onGoingEmergency.length == 1 ){
            _status = "onGoing";
            mfrName = (onGoingEmergency[0].mfrDetails['name']).toString();
            mfrContact = (onGoingEmergency[0].mfrDetails['contact']).toString();
          }
        else if(pendingEmergency != null && pendingEmergency.length == 1 ){
          _status = "pending";
        }
        else if(onGoingEmergency != null && pendingEmergency != null && pendingEmergency.length == 0 && onGoingEmergency.length == 0){
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
        color: const Color(0xffa2150c),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: height/10),
              child: SpinKitRipple(
                color: Colors.red[200],
                size: (width / 1.3),
              ),
            ),
            SizedBox(height: height/20),
            getWidget(_status, mfrName, mfrContact,height,width),
          ],
        )
      );
  }
}


Widget getWidget(String status, String mfrName, String mfrContact, var height, var width){
  String answer;
  if(status == 'onGoing'){
    answer = 'A MFR is on their way!';
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
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20,10,0,20),
                      child: CircleAvatar(
                        backgroundColor: Color(0xff142850),
                        foregroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Text(
                            mfrName,
                            style: TextStyle(
                              fontFamily: 'HelveticaNeueLight',
                              fontSize: 24.0,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 0, 20),
                          child: Text(
                            mfrContact,
                            style: TextStyle(
                              fontFamily: 'HelveticaNeueLight',
                              fontSize: 16.0,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: IconButton(
                              icon: Icon(
                                Icons.call,
                                size: 30,
                                color: Colors.green,
                              ),
                              
                              onPressed: () async {
                                if(await canLaunch("tel:$mfrContact"))
                                {
                                  await launch("tel:$mfrContact");
                                }
                                else
                                  print("could not launch");
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),


                // Text(
                //   'Contact',
                //   style: TextStyle(
                //     fontFamily: 'HelveticaNeueMedium',
                //     fontSize: 16.0,
                //     letterSpacing: 1.0,
                //   ),
                // ),
              ],
            ),
          ),
        )
      ],
    );
  }
  else if(status == 'pending'){
    answer = 'Request Pending...';
  }
  else{
    answer = 'Emergency Ended';
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