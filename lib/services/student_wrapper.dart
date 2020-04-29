import 'package:flutter/material.dart';
import 'package:ems_direct/pages/student_home.dart';
import 'package:ems_direct/pages/live_status.dart';

class StudentWrapper extends StatelessWidget {
  bool _keepSignedIn = false;
  var _userData;

  StudentWrapper(bool keepSignedIn, var userData){
    _keepSignedIn = keepSignedIn;
    _userData = userData;
  }

  @override
  Widget build(BuildContext context) {

    return _userData['loggesIsAs'] == 'emergency' ? LiveStatus(_userData) : StudentHome(_keepSignedIn,_userData);
  }
}
