import 'package:ems_direct/models/user.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/pages/live_status_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:ems_direct/pages/status_list.dart';
import 'package:ems_direct/services/user_database.dart';

class LiveStatus extends StatefulWidget {
  //final UserDatabaseService _userData;
  var _userData;
  LiveStatus(var userData){
    _userData = userData;
  }
  @override
  _LiveStatusState createState() => _LiveStatusState(_userData);
}

class _LiveStatusState extends State<LiveStatus> {
  var _status = StatusData.Data;

  var _userData;
  _LiveStatusState(var userData){
    _userData = userData;
  }
  Stream<DocumentSnapshot> pendingEmergencies;

  @override
  void initState() {
    pendingEmergencies = Firestore.instance.collection('PendingEmergencies').document(_userData.data['rollNo']).snapshots();
    super.initState();
  }

    //final databaseReference = Firestore.instance;


  Stream<QuerySnapshot> ongoingEmergencies = Firestore.instance.collection('OngoingEmergencies').snapshots();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;


    return MultiProvider(
      providers: [
        StreamProvider<DocumentSnapshot>.value(value: pendingEmergencies),
        StreamProvider<QuerySnapshot>.value(value: ongoingEmergencies),
      ],
      child: Scaffold(
        drawer: Container(
          child: Drawer(
            child: Column(
              //this column contains the drawer header, the option to view profile/emergency numbers/available MFRs list
              //also has the option to logout
              children: <Widget>[
                DrawerHeader(
                  //only the ems logo
                  child: Container(
                    child: Image.asset("assets/ems_logo.png"),
                  ),
                ),
                ExpansionTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: const Color(0xff142850),
                  ),
                  title: Text(
                    _userData.data['name'].toString(),
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'HelveticaNeue',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints(maxWidth: width*0.75),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Rollnumber:',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeue',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(width: 2.0),
                          Text(
                            _userData.data['rollNo'].toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeue',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      constraints: BoxConstraints(maxWidth: width*0.75),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Email:',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeue',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(width: 2.0),
                          Text(
                            _userData.data['email'].toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeue',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      constraints: BoxConstraints(maxWidth: width*0.75),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Contact:',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeue',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(width: 1.0),
                          Text(
                            _userData.data['contact'].toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeue',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ListTile(
                  //the option to view emergency numbers - takes you to dummy page
                  title: Text(
                    'Emergency Numbers',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'HelveticaNeue',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/emergencyNumbers');
                    //print('Emergency numbers');
                  },
                ),
              ],
            ),
          )
        ),
        appBar: AppBar(
          backgroundColor: const Color(0xff142850),
          title: Text(
            'Live Status',
            style: TextStyle(
              fontSize: 26,
              fontFamily: 'HelveticaNeue',
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          color: const Color(0xff27496d),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: DisplayList(_userData.data['rollNo'].toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
