import 'package:ems_direct/models/user.dart';
import 'package:ems_direct/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/pages/student_home.dart';
import 'package:ems_direct/pages/SelectLogin.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

// This a wrapping widget that sits just after the splash screen within the application
// widget tree. Its sole purpose is to check if the user stored in disk/locally is currently
// logged in, if yes we intend to show them their homepage directly if not, then show the
// authentication / select login screen flow.

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        return FutureBuilder<FirebaseUser>(
            future: FirebaseAuth.instance.currentUser(),
            builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){

                       if (snapshot.hasData){
                           FirebaseUser user = snapshot.data; // this is your user instance
                           /// is because there is user already logged
                           return StudentHome();
                        }
                         /// other way there is no user logged.
                        else if(snapshot.data == null)
                        {
                         return SelectLogin();
                        }
             }
          );
  }
}