import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleStatus{
  String state;
  String time;

  SingleStatus({this.state,this.time});
}


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

  bool pending = false;

   List<SingleStatus> listOfStatus = new List<SingleStatus>();

  @override
    Widget build(BuildContext context) {
      TimeOfDay timeOfDay = TimeOfDay.fromDateTime(DateTime.now());
      String currentTime = timeOfDay.format(context);

      DocumentSnapshot pendingDoc = Provider.of<DocumentSnapshot>(context);
      try {
        print(pendingDoc.exists);
        if (pendingDoc.exists) {
          listOfStatus.insert(0, new SingleStatus(state: "Emergency Reqeust is pending", time: currentTime));
          pending = true;
        }
        else{
          pending = false;
          QuerySnapshot onGoingDoc = Provider.of<QuerySnapshot>(context);
          listOfStatus.insert(0, new SingleStatus(state: "MFR has been assigned to your emergency", time: currentTime));
        }
      }catch(e){
        print(e);
        pending = false;
      }


    return ListView.builder(
      itemCount: listOfStatus.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 100,
            ),
            child: Card(
              elevation: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 6,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                          EdgeInsets.fromLTRB(10, 29, 0, 20),
                          child: Icon(Icons.fiber_manual_record),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                            EdgeInsets.fromLTRB(10, 30, 0, 20),
                            child: Container(
                              child: Text(
                                listOfStatus[index].state,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'HelveticaNeueLight',
                                ),
                              ),
                            ),
                          ),
                        ),
//                        Flexible(
//                          flex: 2,
                           Align(
                            alignment: Alignment.bottomRight,
                            child: Text(listOfStatus[index].time),
                          ),
//                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
