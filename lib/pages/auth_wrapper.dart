import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/models/user.dart';
import 'package:ems_direct/ops.dart';
import 'package:ems_direct/pages/MFR_home.dart';
import 'package:ems_direct/services/auth.dart';
import 'package:ems_direct/services/user_database.dart';
import 'package:ems_direct/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/pages/student_home.dart';
import 'package:ems_direct/pages/SelectLogin.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

// This a wrapping widget that sits just after the splash screen within the application
// widget tree. Its sole purpose is to check if the user stored in disk/locally is currently
// logged in, if yes we intend to show them their homepage directly if not, then show the
// authentication / select login screen flow.

// utlity function to get user auth and return document Note we are using two futures that depend
// on each other. This function will merge them into a singe future. We will only get the Document future
// if the user is logged in. Otherwise the function returns null
Future getUserDoc() async {

  try{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;
    return await UserDatabaseService(uid:uid).getData();
  }
  catch(e)
  {
    return null;
  }

}


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        return FutureBuilder(
            future: getUserDoc(),
            builder: (BuildContext context, AsyncSnapshot snapshot){

                       if (snapshot.connectionState == ConnectionState.done){

                        // if processing is done and there is data = user currently logged in   
                        if(snapshot.hasData){

                          //if its a student show them their screen
                          if(snapshot.data['emsType'] == ''){
                            return StudentHome();
                          }
                          else{ // the user is ems member
                          
                            if(snapshot.data['loggedInAs'] == 'ops'){
                              return Ops();
                            }
                            else{ //user is mfr
                              return MFRHome();
                            }
                          }                          
                        }
                        //if there is no data user needs to authenticate
                        else{
                          return SelectLogin();
                        }
                      }
                      
                      else //display loading as we are waiting for future
                      {
                        return Loading();
                      }
             }
          );
  }
}