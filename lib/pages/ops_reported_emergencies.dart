import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/models/emergency_models.dart';
import 'package:ems_direct/shared/loading.dart';
import 'package:ems_direct/shared/reported_emergency_tile.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';

GlobalKey _globalKey = GlobalKey();

class ReportedEmergenciesOps extends StatefulWidget {
  Key key = _globalKey;
  @override
  _ReportedEmergenciesOpsState createState() => _ReportedEmergenciesOpsState();
}

class _ReportedEmergenciesOpsState extends State<ReportedEmergenciesOps> {

  int _maxDocs = 1; //todo reset
  int _step = 1; //add additional docs
  bool _firstLoad = true;
  var collectionRef = Firestore.instance.collection('ReportedEmergencies');
  var docs;

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
  List<ReportedEmergencyModel> _reportedEmergencies;

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
      
      body: FutureBuilder(
        future: _getInitialDocs(),
        builder: (BuildContext context, AsyncSnapshot snapshot){

          if(snapshot.connectionState == ConnectionState.done) {

              if(snapshot.hasData){ //!if there is data retrieved

                
                
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
                            RaisedButton(
                              child: Text("Load more"),
                              onPressed: () async {
                                setState(() {
                                  _firstLoad = false;
                                  _maxDocs++;
                                  _getAdditionalDocs();
                                });
                              },
                            )
                          );
                        }
                      ),
                    ),

                  ],)
                );
              }
              else{ //! There is no data in snapshot
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
                            RaisedButton(
                              child: Text("Load more"),
                              onPressed: () async {
                                setState(() {
                                  _firstLoad = false;
                                  _maxDocs++;
                                  _getAdditionalDocs();
                                });
                              },
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