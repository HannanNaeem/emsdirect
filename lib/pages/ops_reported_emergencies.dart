import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/models/emergency_models.dart';
import 'package:ems_direct/shared/loading.dart';
import 'package:ems_direct/shared/reported_emergency_tile.dart';
import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

//---------------------------------------------------------------------------------------------//
// This file contains the code for the "emergencies" section of the records screen for ops
// A list of expandable cards is shown for the recent emergencies that were reported by the mfrs

//---------------------------------------------------------------------------------------------//


GlobalKey _globalKey = GlobalKey();

class ReportedEmergenciesOps extends StatefulWidget {
  Key key = _globalKey;
  @override
  _ReportedEmergenciesOpsState createState() => _ReportedEmergenciesOpsState();
}

class _ReportedEmergenciesOpsState extends State<ReportedEmergenciesOps> {

  int _maxDocs = 10; // documents loaded initially
  int _step = 10; //add additional docs when user wants to load more
  bool _firstLoad = true;
  var collectionRef = Firestore.instance.collection('ReportedEmergencies');
  var docs;

  //A utility function to map the snapshot of documents received from cloud firestore to 
  // ReportedEmergenceyModel = A list is outputted that contains all the Model objects
  List<ReportedEmergencyModel> _getEmergencyList(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return ReportedEmergencyModel(
        patientRollNo: doc.data['patientRollNo'],
        patientGender: doc.data['patientGender'],
        emergencyDate: doc.data['date'].toDate(),
        primaryMfrRollNo: doc.data['primaryMfrRollNo'],
        primaryMfrName: doc.data['primaryMfrName'],
        additionalMfrs: doc.data['additionalMfrs'] ?? "",
        severity: doc.data['severity'],
        patientIsHostelite: doc.data['patientIsHostelite'],
        emergencyType: doc.data['type'],
        emergencyLocation: doc.data['location'] ?? "",
        transportUsed: doc.data['transportUsed'],
        emergencyDetails: doc.data['details'] ?? "",
        bagUsed: doc.data['bagUsed'],
        equipmentUsed: doc.data['equipmentUsed'],
      );
    }).toList();
}
  // to store the converted snapshot into a list
  List<ReportedEmergencyModel> _reportedEmergencies;


  // Althought the code is same as _getAdditionalDocs, this function is being used as an argument to Future builder,
  // When loading for the first time we show a loading screen until this future is resolved. Once resolved it is never
  // re-resolved or it would trigger the loading screen until fetch is complete

  Future _getInitialDocs() async { //used to perform the initial fetch
    try{
      QuerySnapshot snapshot = await collectionRef.orderBy('date', descending: true).limit(_maxDocs).getDocuments();
      if(snapshot!= null)
        _reportedEmergencies = _getEmergencyList(snapshot);
      return snapshot;
    }
    catch(e) {
      print(e);
      return null;
    }
  }

  //This function is used to fetch additional documents requested by user. Note unlike above, this function wont
  // trigger a loading screen as it is not an argument to future builder

  Future _getAdditionalDocs() async { //used to perform the initial fetch
    try{
      QuerySnapshot snapshot = await collectionRef.orderBy('date', descending: true).limit(_maxDocs).getDocuments();
      if(snapshot!= null)
      setState(() {
        _reportedEmergencies = _getEmergencyList(snapshot);
      });
      return snapshot;
    }
    catch(e) {
      print(e);
      return null;
    }
  }
  // switch case 'dictionary' to translate database names to readable UI names
  String _translateKey (String key){
    switch (key) {
      case "crepe": return "Crepe";
      case "openWove" :return "Open wove";
      case "gauze": return "Gauze";
      case "saniplast" : return "Saniplast";
      case "depressors" : return "Depressors";
      case "triangBandage" : return "Triang bandage";
      case "gloves" : return "Gloves";
      case "faceMasks" : return "Face masks";
      case "ors" : return "ORS";
      case "pyodine" : return "Pyodine";
      case "polyfax" : return "Polyfax";
      case "polyfaxPlus" : return "Polyfax plus";
      case "wintogeno" :return "Wintogeno";
      case "deepHeat" :return "Deep heat";
      default: return "";
    }
  }
  // A utlity function to prepare a String for the used equipment map. e.g {crepe: 4, faceMasks: 2} => "Crepe: 5, Face Masks: 2"
  String _translateMap(Map map){
    String output = "";
    map.keys.forEach((key){
      output = output + _translateKey(key.toString()) + ": " + map[key].toString() +", ";
    });
    return output;
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color(0xff27496d),
      appBar: AppBar(
        backgroundColor: const Color(0xff142850),
        title: Text(
          "Emergencies",
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'HelveticaNeueLight',
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      
      // Future builder waits on inital fetch. if its not resolved show loading screen
      body: FutureBuilder(
        future: _getInitialDocs(),
        builder: (BuildContext context, AsyncSnapshot snapshot){

          // if the connection state is done => there is a reply from the backend
          if(snapshot.connectionState == ConnectionState.done) {

              if(snapshot.hasData){ //!if there is data retrieved
                
                // display the data in a cards and mass appropriate data
                return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    Expanded(
                      child: ListView.builder(
                        itemCount: _reportedEmergencies.length + 1,  // +1 because we add the button to load more to the list which is an additional item
                        itemBuilder: (context, index){
                          
                          if(index < _reportedEmergencies.length)   // Everything above the button is cards
                          return Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: ReportedEmergencyTile(
                              patientRollNo: _reportedEmergencies[index].patientRollNo,
                              patientGender: _reportedEmergencies[index].patientGender,
                              emergencyDate: DateFormat.MMMd().format(_reportedEmergencies[index].emergencyDate) + ", " + DateFormat.E().format(_reportedEmergencies[index].emergencyDate) + "\n"+ DateFormat.Hm().format(_reportedEmergencies[index].emergencyDate),
                              primaryMfrRollNo: _reportedEmergencies[index].primaryMfrRollNo,
                              primaryMfrName: _reportedEmergencies[index].primaryMfrName,
                              additionalMfrs: _reportedEmergencies[index].additionalMfrs == "" ? "None" : _reportedEmergencies[index].additionalMfrs,
                              severity: _reportedEmergencies[index].severity,
                              patientIsHostelite: _reportedEmergencies[index].patientIsHostelite,
                              emergencyType: _reportedEmergencies[index].emergencyType,
                              emergencyLocation: _reportedEmergencies[index].emergencyLocation == "" ? "No location" :  _reportedEmergencies[index].emergencyLocation,
                              transportUsed: _reportedEmergencies[index].transportUsed == "Yes" ? "Transport Used" : "",
                              emergencyDetails: _reportedEmergencies[index].emergencyDetails == "" ? "No details" : _reportedEmergencies[index].emergencyDetails,
                              bagUsed: _reportedEmergencies[index].bagUsed,
                              equipmentUsed: _reportedEmergencies[index].equipmentUsed == null ? "None" : _translateMap(_reportedEmergencies[index].equipmentUsed),
                            ),
                          ); 
                          else                  // On the last index load the button to showmore
                          return Padding(       
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                              
                                RaisedButton(                        
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                  color: Colors.grey[100],//const Color(0xFF73CDE8),
                                  shape: CircleBorder(),
                                  onPressed: () async {  // when pressed toggle the first load boolean as we dont
                                    setState(() {        // want to display the loading screen
                                      _firstLoad = false;
                                      _maxDocs = _maxDocs + _step;
                                      _getAdditionalDocs();
                                    });
                                  },
                                ),
                                //!Hit text
                                Text(
                                  "Tap to load more..",
                                  style: TextStyle(
                                    fontFamily: "HelveticaNeueLight",
                                    fontSize: 13,
                                    color: Colors.grey[300],
                                  )
                                )
                                
                              ],
                            ),
                          );
                        }
                      ),
                    ),

                  ],)
                );
              }
              else{ //! There is no data in snapshot but there was a reply from the backend show sad face :(
                return Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "No emergencies reported :(",
                    style: TextStyle(
                      fontFamily: "HelveticalNeueLight",
                      color: Colors.grey[600],
                      fontSize: 15,
                    ),
                  ),
                );
              }
          } else { //!display loading as fetch isnt compelete 
            if(_firstLoad){
              return Loading();
            }
            else{ //! Display the old state if this isnt the first load
                return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    Expanded(
                      child: ListView.builder(
                        itemCount: _reportedEmergencies.length + 1,
                        itemBuilder: (context, index){
                          
                          if(index < _reportedEmergencies.length)
                          return Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: ReportedEmergencyTile(
                              patientRollNo: _reportedEmergencies[index].patientRollNo,
                              patientGender: _reportedEmergencies[index].patientGender,
                              emergencyDate: DateFormat.MMMd().format(_reportedEmergencies[index].emergencyDate) + ", " + DateFormat.E().format(_reportedEmergencies[index].emergencyDate) + "\n"+ DateFormat.Hm().format(_reportedEmergencies[index].emergencyDate),
                              primaryMfrRollNo: _reportedEmergencies[index].primaryMfrRollNo,
                              primaryMfrName: _reportedEmergencies[index].primaryMfrName,
                              additionalMfrs: _reportedEmergencies[index].additionalMfrs == "" ? "None" : _reportedEmergencies[index].additionalMfrs,
                              severity: _reportedEmergencies[index].severity,
                              patientIsHostelite: _reportedEmergencies[index].patientIsHostelite,
                              emergencyType: _reportedEmergencies[index].emergencyType,
                              emergencyLocation: _reportedEmergencies[index].emergencyLocation == "" ? "No location" :  _reportedEmergencies[index].emergencyLocation,
                              transportUsed: _reportedEmergencies[index].transportUsed == "Yes" ? "Transport Used" : "",
                              emergencyDetails: _reportedEmergencies[index].emergencyDetails == "" ? "No details" : _reportedEmergencies[index].emergencyDetails,
                              bagUsed: _reportedEmergencies[index].bagUsed,
                              equipmentUsed: _reportedEmergencies[index].equipmentUsed == null ? "None" : _translateMap(_reportedEmergencies[index].equipmentUsed),
                            ),
                          );
                          else
                          return(
                            Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                              
                                SpinKitThreeBounce(
                                  size: 30,
                                  color: Colors.grey[100],
                                )
                                
                              ],
                            ),
                          )
                          );
                        }
                      ),
                    ),

                  ],)
                );
            }
          }
        }
      ),
    );
  }
}