import 'package:ems_direct/ops.dart';
import 'package:ems_direct/services/emergency_alert_ops.dart';
import 'package:flutter/material.dart';


class OpsWrapper extends StatelessWidget {

  bool _keepSignedIn = false;
  var _userData;

  OpsWrapper(bool keepSignedIn, var userData){
    _keepSignedIn = keepSignedIn;
    _userData = userData;
  }

  @override
  Widget build(BuildContext context) {
    
    return Stack(
      children: <Widget>[
        AlertOps(),
        OpsHome(_keepSignedIn, _userData, opsGlobalKey)
      ],
      
    );
  }
}