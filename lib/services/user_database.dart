import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabaseService {

  final String uid;

  UserDatabaseService({ this.uid });

  //collection reference
  final CollectionReference userCollection = Firestore.instance.collection('UserData');

  //utlity to update user data
  Future updateUserData(String name, String rollNo, String contact, String email, String emsType, String loggedInAs) async {

      return await userCollection.document(uid).setData({
        'name' : name,
        'rollNo' : rollNo,
        'contact' : contact,
        'email' : email,
        'emsType' : emsType,
        'loggedInAs' : loggedInAs,
      });
  }

  Future updateLoggedIn(String loggedInAs) async {
    return await userCollection.document(uid).updateData({
      'loggedInAs' : loggedInAs,
    });
  }

  Future getData() async {
    return await userCollection.document(uid).get();
  }


}