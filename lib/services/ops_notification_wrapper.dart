import 'package:ems_direct/models/emergency_models.dart';
import 'package:ems_direct/ops.dart';
import 'package:ems_direct/services/emergency_alert_ops.dart';
import 'package:ems_direct/services/ops_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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