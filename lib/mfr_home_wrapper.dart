import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/services/pending_emergency_alert_MFR.dart';
import 'package:ems_direct/pages/MFR_home.dart';
import 'package:provider/provider.dart';

class MfrWrapper extends StatelessWidget {
  bool _keepSignedIn = false;
  var _userData;
  static final _databaseReference = Firestore.instance;

  MfrWrapper(bool keepSignedIn, var userData) {
    _keepSignedIn = keepSignedIn;
    _userData = userData;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AlertFunctionMfr(_userData),
        MFRHome(_keepSignedIn, _userData),
      ],
    );
  }
}
