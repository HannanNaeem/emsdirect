import 'package:ems_direct/models/emergency_models.dart';
import 'package:ems_direct/ops.dart';
import 'package:ems_direct/services/emergency_alert_ops.dart';
import 'package:ems_direct/services/ops_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// This wrapper puts the emergency alert logic and listener with all its functions
// above the home screen. We can then display dialogs on top by keeping the wdigets independant
// They share information from the parent providers. Among them via a global key = used to change screen
// in reposonse to dialog select



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
        StreamProvider<List<EquipmentBagModel>>.value(
          value:OpsDatabaseService().equipmentBagsStream,
          child: OpsHome(_keepSignedIn, _userData, opsGlobalKey)
        )
      ],
      
    );
  }
}