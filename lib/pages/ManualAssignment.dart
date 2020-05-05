import 'package:ems_direct/models/emergency_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ems_direct/pages/MfrInformation.dart';

// Displays MFR options to choose from for pending emergencies assignment

class ManualAssignment extends StatefulWidget {
  // stores all the emergency information
  var emergencyInformation;

  // Constructor
  ManualAssignment(var emergencyInfo) : super() {
    emergencyInformation = emergencyInfo;
  }

  @override
  ManualAssignmentState createState() => new ManualAssignmentState();
}

class ManualAssignmentState extends State<ManualAssignment> {
  // will be storing list of available MFRs documents
  var availableMfrsList;


  @override
  // Called when this object is removed from the tree permanently
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // snapshot list of available Mfrs
    availableMfrsList = Provider.of<List<AvailableMfrs>>(context);

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
                            'Patient roll no: ' + widget.emergencyInformation.patientRollNo,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'HelveticaNeueLight',
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            'Patient Contact: ' + widget.emergencyInformation.patientContactNo,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'HelveticaNeueLight',
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            'Gender Preference: ' + widget.emergencyInformation.genderPreference,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'HelveticaNeueLight',
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            'Severity: ' + widget.emergencyInformation.severity,
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
                    // iterating through the list of available mfr's who are free and displaying their information in cards
                    itemCount: availableMfrsList == null
                        ? 0
                        : availableMfrsList.length,
                    itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 20, 0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: 100,
                              minWidth: 100,
                            ),
                            // making an object of MfrInformation and passing it all the information of the mfr and emergency
                            child: MfrInformation(
                              availableMfrsList[index].name,
                              availableMfrsList[index].rollNo,
                              availableMfrsList[index].contact,
                              availableMfrsList[index].gender,
                              availableMfrsList[index].isSenior,
                                widget.emergencyInformation
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