import 'package:ems_direct/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object from Firebase reply
  User _userFromFirebaseUser(FirebaseUser user) {

    return user != null ? User(uid: user.uid) : null;

  }

  // Auth user stream -> listens to firebase auth for changes in auth status
  Stream<User> get user {

    return _auth.onAuthStateChanged
    // let us now map FirebaseUser(which has unnecessary info) to our user model and return
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
    
    //similar implementation below:
    .map(_userFromFirebaseUser);


  }

  // sign in anon
  Future signInAnon() async {

    try{
     
     AuthResult result = await _auth.signInAnonymously();
     FirebaseUser user = result.user;

     return _userFromFirebaseUser(user);

    }
    catch(e)
    {

      print(e.toString());
      return null;

    }

  }


  // sign in email & password


  // register


  // log out
}