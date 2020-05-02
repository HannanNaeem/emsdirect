import 'package:firebase_messaging/firebase_messaging.dart';

class CloudMessagingService {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  //get token
  void getToken(){
    _firebaseMessaging.getToken().then((deviceToken){
      print("Device Token: $deviceToken");
    });
  }

  void configureFirebaseListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String,dynamic> message) async {
        //print('onMessage: $message');
      },
      onLaunch: (Map<String,dynamic> message) async {
        //print('onMessage: $message');
      },
      onResume: (Map<String,dynamic> message) async {
        //print('onMessage: $message');
      },

    );
  }

}