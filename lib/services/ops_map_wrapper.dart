import 'package:ems_direct/services/ops_database.dart';
import 'package:ems_direct/models/emergency_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ems_direct/pages/MapOPS.dart';


class OpsMapWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return StreamProvider<List<PendingEmergencyModel>>.value(
      value: OpsDatabaseService().pendingStream,
      child: MapOPS()
      );
  }
}