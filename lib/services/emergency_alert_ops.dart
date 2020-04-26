import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ems_direct/models/emergency_models.dart';


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
    var _pendingEmergencyList = Provider.of<List<PendingEmergencyModel>>(context);
    //print(_ignored.documents);
    

    void _showAlert(){
     
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
              fontSize: 20,
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
            Padding(
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

                  Navigator.of(context).pop();
                },
              ),
            ),
            SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
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

                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      );
    }
    

    //Calls the show alert function after build is complete to avoid repeated alerts
    if (_pendingEmergencyList != null)
    {
      _pendingEmergencyList.forEach((emergency){
        print(emergency.declines);
        print(emergency.declinedBy);
        print(emergency.genderPreference);
        print(emergency.patientRollNo);
        print(emergency.location);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          _showAlert());//_ignored.documents.length, _ignored.documents[0], _width, _height));
    }

    return Container();
  }
}