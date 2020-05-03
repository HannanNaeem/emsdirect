import 'package:ems_direct/models/emergency_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ems_direct/pages/MfrInformation.dart';


class ManualAssignment extends StatefulWidget {
  var _emergencyInformation;
  ManualAssignment(var EmergencyInformation) : super() {
    _emergencyInformation = EmergencyInformation;
  }

  @override
  ManualAssignmentState createState() => new ManualAssignmentState(_emergencyInformation);
}

class ManualAssignmentState extends State<ManualAssignment> {
  @override
  var _emergencyInformation;
  ManualAssignmentState(var EmergencyInformation) {
    _emergencyInformation = EmergencyInformation;
  }

  @override
  void dispose(){
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // ----------------------------- snapshot list ---------------------------------//
    var _availableMfrsList = Provider.of<List<AvailableMfrs>>(context);
    if(_availableMfrsList != null) {_availableMfrsList.forEach((mfr){print("manual-------------------------${mfr.name}");});}

    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff142850),
            title: Text(
              'Assign MFR',
              style: TextStyle(
                fontFamily: 'HelveticaNeueLight',
                letterSpacing: 2.0,
                fontSize: 24,
              ),
            ),
            centerTitle: true,
            leading: new IconButton(
              icon: new Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          backgroundColor: const Color(0xff27496d),
          body: Container(
            child: Column(
              children: <Widget>[
               Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Patient roll no: ' + _emergencyInformation.patientRollNo,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'HelveticaNeueLight',
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            'Patient Contact: ' + _emergencyInformation.patientContactNo,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'HelveticaNeueLight',
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            'Gender Preference: ' + _emergencyInformation.genderPreference,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'HelveticaNeueLight',
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            'Severity: ' + _emergencyInformation.severity,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'HelveticaNeueLight',
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                Expanded(
                  child: ListView.builder(
                    itemCount: _availableMfrsList == null
                        ? 0
                        : _availableMfrsList.length,
                    itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 20, 0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: 100,
                              minWidth: 100,
                            ),
                            child: MfrInformation(
                              _availableMfrsList[index].name,
                              _availableMfrsList[index].rollNo,
                              _availableMfrsList[index].contact,
                              _availableMfrsList[index].gender,
                              _availableMfrsList[index].isSenior,
                            ),
                          ),
                        );

                      },
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }


}