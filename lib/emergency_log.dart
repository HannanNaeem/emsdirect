import 'package:ems_direct/log_card.dart';
import 'package:ems_direct/models/emergency_models.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/log_data.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Cotains a simple widget tree with list builder of cards for emergency logs Ops screen


class EmergencyLog extends StatefulWidget {
  @override
  _LogState createState() => _LogState();
}

class _LogState extends State<EmergencyLog> {
  var logData = LogData.data;

  @override
  Widget build(BuildContext context) {


    var _onGoingEmergencyList = Provider.of<List<OngoingEmergencyModel>>(context);

    return Scaffold(
      backgroundColor: const Color(0xff27496d),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _onGoingEmergencyList == null
                    ? 0
                    : _onGoingEmergencyList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 100,
                      ),
                      child: LogCard(
                          _onGoingEmergencyList[index].mfrDetails['name'],
                          _onGoingEmergencyList[index].mfr,
                          _onGoingEmergencyList[index].mfrDetails['contact'],
                          _onGoingEmergencyList[index].genderPreference,
                          _onGoingEmergencyList[index].severity,
                          DateFormat.jm().format(_onGoingEmergencyList[index].reportingTime),
                          _onGoingEmergencyList[index].patientRollNo,
                          _onGoingEmergencyList[index].patientContactNo,

                          ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
