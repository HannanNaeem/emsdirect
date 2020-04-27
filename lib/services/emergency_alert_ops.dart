import 'package:ems_direct/ops.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ems_direct/models/emergency_models.dart';



List<String> _alertedBuffer =  [];

class AlertOps extends StatefulWidget {

  @override
  _AlertOpsState createState() => _AlertOpsState();
}

class _AlertOpsState extends State<AlertOps> {
  

  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;
    var _width = screenSize.width;
    var _height = screenSize.height;
    var _declinedEmergencyList = Provider.of<List<DeclinedEmergencyModel>>(context);
    var _severeEmergencyList = Provider.of<List<SevereEmergencyModel>>(context);
    
    //! -------------------------------------- Alert for severe emergencies --------------------------------//


    void _showAlertSevere(String severity, String patientRollNo, String genderPreference, String patientContactNo){
     
     showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            "New Severe Emergency!",
            style: TextStyle(
              fontFamily: 'HelveticaNeueLight',
              letterSpacing: 2.0,
              fontSize: 24,
              color: const Color(0xffee0000),
            ),
          ),
          content: Text(
            "Please manually assign a MFR\n\n Patient: ${patientRollNo}\n Contact: ${patientContactNo}\n Severity: ${severity}\n Gender Preferred: $genderPreference",
            style: TextStyle(
              fontFamily: 'HelveticaNeueLight',
              letterSpacing: 2.0,
              fontSize: 18,
              //color: Colors.grey[600],
            ),
          ),
          actions: <Widget>[
            Center(
              child: Padding(
                //alignment: Alignment.bottomLeft,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: FlatButton(
                  child: Text(
                    'Go to Map',
                    style: TextStyle(
                      fontFamily: 'HelveticaNeueLight',
                      //fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      fontSize: 20,
                      color: const Color(0xff1a832a),
                    ),
                  ),
                  onPressed: () {
                    print('go to map');
                    opsGlobalKey.currentState.setPage(2);                  
                    Navigator.of(context).pop();
                    
                  },
                ),
              ),
            ),
            Divider(),
            SizedBox(width: 10),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: FlatButton(
                  child: Text(
                    'Go to Notifications',
                    style: TextStyle(
                      fontFamily: 'HelveticaNeueLight',
                      letterSpacing: 2,
                      fontSize: 20,
                      color: const Color(0xffee0000),
                    ),
                  ),
                  onPressed: () {
                    print('go to notifications');
                    opsGlobalKey.currentState.setPage(1);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }


    //! -------------------------------------- Alert for ignored/declined emergencies -----------------------//
    void _showAlertIgnored(){
     
     showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            "Ignored Emergency!",
            style: TextStyle(
              fontFamily: 'HelveticaNeueLight',
              letterSpacing: 2.0,
              fontSize: 24,
              color: const Color(0xffee0000),
            ),
          ),
          content: Text(
            "Please manually assign a MFR",
            style: TextStyle(
              fontFamily: 'HelveticaNeueLight',
              letterSpacing: 2.0,
              fontSize: 18,
              //color: Colors.grey[600],
            ),
          ),
          actions: <Widget>[
            Center(
              child: Padding(
                //alignment: Alignment.bottomLeft,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: FlatButton(
                  child: Text(
                    'Go to Map',
                    style: TextStyle(
                      fontFamily: 'HelveticaNeueLight',
                      //fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      fontSize: 20,
                      color: const Color(0xff1a832a),
                    ),
                  ),
                  onPressed: () {
                    print('go to map');
                    opsGlobalKey.currentState.setPage(2);  
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            Divider(),
            SizedBox(width: 10),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: FlatButton(
                  child: Text(
                    'Go to Notifications',
                    style: TextStyle(
                      fontFamily: 'HelveticaNeueLight',
                      letterSpacing: 2,
                      fontSize: 20,
                      color: const Color(0xffee0000),
                    ),
                  ),
                  onPressed: () {
                    print('go to notifications');
                    opsGlobalKey.currentState.setPage(1);  
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    

    //Calls the show alert function after build is complete to avoid repeated alerts
    if (_declinedEmergencyList != null && _declinedEmergencyList.length != 0)
    {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          _showAlertIgnored());//_ignored.documents.length, _ignored.documents[0], _width, _height));
    }

    // Alerting for
    if (_severeEmergencyList != null && _severeEmergencyList.length != 0)
    {
      List<String> _iterationBuffer = [];
      _severeEmergencyList.forEach((emergency){
        
        if(!_alertedBuffer.contains(emergency.patientRollNo)){
              
              WidgetsBinding.instance.addPostFrameCallback((_) =>
                _showAlertSevere(emergency.severity,emergency.patientRollNo,emergency.genderPreference,emergency.patientContactNo));
              print("------before-------$_alertedBuffer");
              _iterationBuffer.add(emergency.patientRollNo);

              
        }
        else{print("already informed!");}
        
      });

      _alertedBuffer.addAll(_iterationBuffer);
      print("------after-------$_alertedBuffer");
    }

    // Even if list returns empty i.e the change is to the list being empty -> update buffer.
    if(_severeEmergencyList != null && _alertedBuffer.length != 0){
      List<String> _iterationBuffer = new List<String>.from(_alertedBuffer);
      //!Cleaning up buffer
      //remove any emergency in buffer that is not in snapshot list
      _alertedBuffer.forEach((oldEmergencyRoll){
        if(!(_severeEmergencyList.map((emergency)=>(emergency.patientRollNo))).contains(oldEmergencyRoll)){
          
          _iterationBuffer.remove(oldEmergencyRoll);
        }
      });

      _alertedBuffer = new List<String>.from(_iterationBuffer);
    }



    return Container();
  }
}