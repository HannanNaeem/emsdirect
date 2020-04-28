import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:ems_direct/models/emergency_models.dart';

class DisplayList extends StatefulWidget {
  var _rollNum;
  DisplayList(var rollNum){
    _rollNum = rollNum;
  }

  @override
  _DisplayListState createState() => _DisplayListState(_rollNum);
}

class _DisplayListState extends State<DisplayList> {

  var _rollNum;
  _DisplayListState(var rollNum){
    _rollNum = rollNum;
  }

  @override
    Widget build(BuildContext context) {
      TimeOfDay timeOfDay = TimeOfDay.fromDateTime(DateTime.now());
      String currentTime = timeOfDay.format(context);
      String _status = 'Loading';

      var pendingEmergency = Provider.of<List<PendingEmergencyModel>>(context);
      var onGoingEmergency = Provider.of<List<OngoingEmergencyModel>>(context);
      try{
        if(onGoingEmergency.length == 1 && onGoingEmergency != null){
            _status = "onGoing";
          }
        else if(pendingEmergency.length == 1 && pendingEmergency != null){
          _status = "pending";
        }
        else{
          _status = "ended";
        }
      }catch(e){
        print(e);
      }

      return Container(
        color: Colors.red[400],
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment(-1,-1),
              child: SpinKitRipple(
                color: Colors.red[200],
                size: 80.0,
              ),
            ),
            Align(
              alignment: Alignment(0,0.1),
              child:getWidget(_status),
            )
          ],
        )
      );
  }
}


Widget getWidget(String status){
  if(status == 'onGoing'){
    return Text(
      'MFR has been assigned to you emergency',
      style: TextStyle(
        fontSize: 20.0,
        fontFamily: 'HelveticaNeueLight',
        color: Colors.black,
        letterSpacing: 2.0,
      ),
    );
  }
  else if(status == 'pending'){
    return Text(
      'Emergency Request is Pending',
      style: TextStyle(
        fontSize: 20.0,
        fontFamily: 'HelveticaNeueLight',
        color: Colors.black,
        letterSpacing: 2.0,
      ),
    );
  }
  else if(status == 'loading'){
    return Text(
      'loading',
      style: TextStyle(
        fontSize: 20.0,
        fontFamily: 'HelveticaNeueLight',
        color: Colors.black,
        letterSpacing: 2.0,
      ),
    );
  }
  else{
    return Text(
      'Your emergency ended',
      style: TextStyle(
        fontSize: 20.0,
        fontFamily: 'HelveticaNeueLight',
        color: Colors.black,
        letterSpacing: 2.0,
      ),
    );
  }
}

