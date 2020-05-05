import 'package:ems_direct/models/user.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/pages/live_status_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:ems_direct/pages/status_list.dart';
import 'package:ems_direct/models/emergency_models.dart';
import 'package:ems_direct/services/ops_database.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';


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
          width: width * 0.8,
          child: Drawer(
            child: Column(
              //this column contains the drawer header, the option to view profile/emergency numbers/available MFRs list
              //also has the option to logout
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: height * 0.25,
                    child: Image(
                      image: AssetImage("assets/ems_logo.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                ConfigurableExpansionTile(
                  animatedWidgetFollowingHeader: const Icon(
                    Icons.expand_more,
                    color: const Color(0xFF707070),
                  ),
                  //headerExpanded: Flexible(child: Center(child: Text("A Header Changed"))),
                  header: Container(
                      color: Colors.transparent,
                      child: Center(
                          child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.account_circle,
                            color: const Color(0xff142850),
                            size: height / 20,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            _userData.data['name'].toString(),
                            style: TextStyle(
                              fontSize: 19,
                              fontFamily: 'HelveticaNeueLight',
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ))),
                  children: [
                    SizedBox(height: 10.0),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Roll number: ',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeueLight',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(width: 2.0),
                          Text(
                            _userData.data['rollNo'].toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeueLight',
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Email: ',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeueLight',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(width: 2.0),
                          Text(
                            _userData.data['email'].toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeueLight',
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Contact: ',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeueLight',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(width: 1.0),
                          Text(
                            _userData.data['contact'].toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeueLight',
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
                ListTile(
                  //the option to view emergency numbers - takes you to dummy page
                  title: Text(
                    'Emergency Numbers',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'HelveticaNeueLight',
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
          ),
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
