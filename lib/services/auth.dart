import 'package:ems_direct/models/user.dart';
import 'package:ems_direct/services/user_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// This file contains the auth class, instead on making an instance of firebase auth
// and using them everywhere, just create an instance of this class and call the
// methods that are needed.

// classified as service.

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in email & password
  Future signIn(String email, String password, String emsType) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user = result.user;

      //get uid
      String uid = user.uid;
      //get firestore emsType
      var document = await UserDatabaseService(uid: uid).getData();
      var token = await FirebaseMessaging().getToken();

      //if token is null return null,
      if(token == null)
        return null;
      

      String storedEmsType = document.data['emsType'].toString();

      print("----------------------STORED EMS TYPE IS $storedEmsType");


      //there are three policies we must enforce
      // -> student cannot log as someone else => emsType == ''
      // -> mfr cannot login as ops
      // -> there is no email verification for ems Members

      //handle student
      //Student trying to login as someone else
      if (emsType != '' && storedEmsType == '') {
        _auth.signOut();
        return null;
      }
      //For student check if email is verified
      if (emsType == '' && !user.isEmailVerified) {
        _auth.signOut();
        return null;
      }

      //Handle MFR
      //MFR trying to login as ops
      if (emsType == 'ops' && storedEmsType == 'mfr') {
        _auth.signOut();
        return null;
      }
      //before finally letting user to log in make sure the device tokens are in sync
      if(document.data['token'] != token ) {
        //set the token as new device token
        await UserDatabaseService(uid:uid).updateToken(token);

      }

      //Everything else is okay! Set loggedInAs for ems users
      if (storedEmsType != '') {
        await UserDatabaseService(uid: uid).updateLoggedIn(emsType);
      }
      return document;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register
  Future signUp(String email, String password, String name, String rollNo,
      String contact) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      try {
        await user.sendEmailVerification();
        _auth.signOut();
      } catch (e) {
        throw e;
      }

      //create a document for the user with the uid
      await UserDatabaseService(uid: user.uid)
          .updateUserData(name, rollNo, contact, email, '', '');

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //currentUser
  Future currentUser() async {
    FirebaseUser user = await _auth.currentUser();
    if (user == null)
      return null;
    else
      return user.uid;
  }

  // log out
  Future logOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
