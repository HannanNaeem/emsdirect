import 'package:ems_direct/services/ops_database.dart';
import 'package:ems_direct/models/emergency_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ems_direct/pages/ManualAssignment.dart';

//------------------------------------------
// Setting up providers the OPS will be listening to on top of their maunal assignment screen- > available mfrs that are also occupied
// this is needed because this is a separate query stream
//------------------------------------------


class OpsManualAssignmentWrapper extends StatelessWidget {
  var _emergencyInformation;
  OpsManualAssignmentWrapper(var emergencyInformation){
    _emergencyInformation = emergencyInformation;
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<AvailableMfrs>>.value(
      value:  OpsDatabaseService().availableMfrStream2,
      child: StreamProvider<List<PendingEmergencyModel>>.value(
          value: OpsDatabaseService().pendingStream,
          child: ManualAssignment(_emergencyInformation)
      ),
    );

  }



}