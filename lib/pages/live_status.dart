import 'package:ems_direct/models/user.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/pages/live_status_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:ems_direct/pages/status_list.dart';
import 'package:ems_direct/models/emergency_models.dart';
import 'package:ems_direct/services/ops_database.dart';

class LiveStatus extends StatefulWidget {

  bool _keepSignedIn;
  var _userData;
  LiveStatus(bool keepSignedIn, var userData){
    _keepSignedIn = keepSignedIn;
    _userData = userData;
  }

  @override
  _LiveStatusState createState() => _LiveStatusState(_keepSignedIn, _userData);
}

class _LiveStatusState extends State<LiveStatus> {

  bool _keepSignedIn;
  var _userData;
  _LiveStatusState(keepSignedIn, var userData){
    _keepSignedIn = keepSignedIn;
    _userData = userData;
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;


    return MultiProvider(
      providers: [
        StreamProvider<List<PendingEmergencyModel>>.value(value: OpsDatabaseService().studentPendingStream(_userData.data['rollNo'].toString())),
        StreamProvider<List<OngoingEmergencyModel>>.value(value: OpsDatabaseService().studentOnGoingStream(_userData.data['rollNo'].toString())),
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
                child: DisplayList(_keepSignedIn,_userData),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
