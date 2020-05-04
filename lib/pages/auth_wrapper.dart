import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/models/emergency_models.dart';
import 'package:ems_direct/models/emergency_models.dart';
import 'package:ems_direct/models/user.dart';
import 'package:ems_direct/ops.dart';
import 'package:ems_direct/pages/MFR_home.dart';
import 'package:ems_direct/services/auth.dart';
import 'package:ems_direct/services/ops_database.dart';
import 'package:ems_direct/services/ops_notification_wrapper.dart';
import 'package:ems_direct/services/mfr_database.dart';
import 'package:ems_direct/services/user_database.dart';
import 'package:ems_direct/shared/loading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/pages/student_home.dart';
import 'package:ems_direct/pages/SelectLogin.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ems_direct/mfr_home_wrapper.dart';
import 'package:ems_direct/services/student_wrapper.dart';

// This a wrapping widget that sits just after the splash screen within the application
// widget tree. Its sole purpose is to check if the user stored in disk/locally is currently
// logged in, if yes we intend to show them their homepage directly if not, then show the
// authentication / select login screen flow.

// utlity function to get user auth and return document Note we are using two futures that depend
// on each other. This function will merge them into a singe future. We will only get the Document future
// if the user is logged in. Otherwise the function returns null
Future getUserDoc() async {
  try {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;
    
    //before proceeding check if token is the same as stored in the back end
    dynamic doc = await UserDatabaseService(uid: uid).getData();
    dynamic token = await FirebaseMessaging().getToken();
    //failing to get token results in not letting the user log in
    if(token == null){
      print("----------Failed to get token");
      return null;
    }

    if(doc.data['token'] != token)
    {
      //set token at back end to new token
      await UserDatabaseService(uid:uid).updateToken(token);
    
    }

    return doc;
  } catch (e) {
    return null;
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserDoc(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // if processing is done and there is data = user currently logged in
            if (snapshot.hasData) {
              print(snapshot.data);
              if (snapshot.data['loggedInAs'] == 'ops') {
                // user is logged in as ops

                return StreamProvider<List<OngoingEmergencyModel>>.value(
                  value: OpsDatabaseService().onGoingStream,
                  child: StreamProvider<List<AvailableMfrs>>.value(
                    value: OpsDatabaseService().availableMfrStream,
                    child: StreamProvider<List<SevereEmergencyModel>>.value(
                      value: OpsDatabaseService().severeStream,
                      child: StreamProvider<List<DeclinedEmergencyModel>>.value(
                          value: OpsDatabaseService().declinedStream,
                          child: OpsWrapper(true, snapshot.data)),
                    ),
                  ),
                );
              } else if (snapshot.data['loggedInAs'] == 'mfr') {
                //user is logged in as mfr
                return StreamProvider<List<PendingEmergencyModel>>.value(
                  value: MfrDatabaseService().pendingStream,
                  child: StreamProvider<List<OngoingEmergencyModel>>.value(
                      value: MfrDatabaseService().ongoingStream,
                      child: MfrWrapper(true, snapshot.data)),
                );
              } else {
                // user is logged in as student
                return StudentWrapper(true,snapshot.data);//StudentHome(true, snapshot.data); // did this to include direct routing to live status
              }
            }

            //if there is no data user needs to authenticate
            else {
              return SelectLogin();
            }
          } else //display loading as we are waiting for future
          {
            return Loading();
          }
        });
  }
}
