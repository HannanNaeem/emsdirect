import 'package:flutter/material.dart';
import 'package:ems_direct/pages/live_status_data.dart';

class LiveStatus extends StatefulWidget {
  @override
  _LiveStatusState createState() => _LiveStatusState();
}

class _LiveStatusState extends State<LiveStatus> {
  var _status = StatusData.Data;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    int _rollnumber = 21100118;
    int _contact = 03362356254;
    String _email = '21100118@lums.edu.pk';
    return Scaffold(
      drawer: Container(
        child: Drawer(
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
                  ),
                  title: Text(
                    'Harum Naseem',
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
                            '$_rollnumber',
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
                            _email,
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
                            '$_contact',
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
          ),
        )
      ),
      appBar: AppBar(
        backgroundColor: Colors.cyan[800],
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _status.length,
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
                                          _status[index]['text'],
                                          style: TextStyle(
                                            //color: const Color(0xff3596b5),
                                            fontSize: 17,
                                            fontFamily: 'HelveticaNeue',
                                            //fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                //child: Card(elevation: 10, child: Text('Hello World')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
