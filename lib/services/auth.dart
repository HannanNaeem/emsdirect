import 'package:ems_direct/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';


// This file contains the auth class, instead on making an instance of firebase auth
// and using them everywhere, just create an instance of this class and call the 
// methods that are needed. 

// classified as service.


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  // // Auth user stream -> listens to firebase auth for changes in auth status
  // Stream<FirebaseUser> get user {

  //   return _auth.onAuthStateChanged;
  //   // let us now map FirebaseUser(which has unnecessary info) to our user model and return
  //   //.map((FirebaseUser user) => _userFromFirebaseUser(user));
    
  //   //similar implementation below:
  


  // }

  // sign in anon
  Future signInAnon() async {

    try{
     
     AuthResult result = await _auth.signInAnonymously();
     FirebaseUser user = result.user;

     return user;

    }
    catch(e)
    {

      print(e.toString());
      return null;

    }

  }


  // sign in email & password
  Future signIn(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  // register
  Future signUp(String email, String password) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    }
    catch(e){
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
    try{
      return await _auth.signOut();
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }
}