import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/pages/emergency_numbers.dart';
import 'package:ems_direct/pages/available_MFRs.dart';

//This is the main homepage for any MFR login
class MFRHome extends StatefulWidget {
  @override
  _MFRHomeState createState() => _MFRHomeState();
}

class _MFRHomeState extends State<MFRHome> {
  //Tells whether toggle switch is to be on or off
  bool isAvailable = false;

  @override
  Widget build(BuildContext context) {
    //Getting screen dimensions to adjust widgets accordingly
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    //Defines the whole layout of the homepage
    return Scaffold(
      backgroundColor: Colors.grey[50],
      //This contains the widgets seen in the drawer - also has navigation included
      drawer: Container(
        width: width *
            0.8, //making sure drawer extends to 80% of whatever screen it is
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
              Padding(
                padding: EdgeInsets.fromLTRB(width * 0.8 * 0.2, 0, 0, 0),
                child: Row(
                  //only the profile viewing option - an icon and a text
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.account_circle),
                      color: Colors.cyan[800],
                      onPressed: () {
                        print('MFR personal info');
                      },
                      iconSize: height / 20,
                    ),
                    Text(
                      'Harum Naseem',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'HelveticaNeueMedium',
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                //the option to view emergency numbers - takes you to dummy page
                title: Text(
                  'Emergency Numbers',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'HelveticaNeueMedium',
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/emergencyNumbers');
                  //print('Emergency numbers');
                },
              ),
              ListTile(
                //the option to view available MFRs list - takes you to dummy page
                title: Text(
                  'List of Available MFRs',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'HelveticaNeueMedium',
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/availableMfrs');
                  //print('List of Available MFRs');
                },
              ),
              Expanded(
                //the option to logout (bottom center aligned)
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:
                        EdgeInsets.fromLTRB(width * 0.8 * 0.24, 0, 0, 10.0),
                    child: Row(
                      //has the icon and text
                      children: <Widget>[
                        IconButton(
                          icon: Image(
                            image: AssetImage('assets/logout.png'),
                            fit: BoxFit.fill,
                            color: Colors.cyan[800],
                          ),
                          color: Colors.cyan[800],
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Are you sure?",
                                      style: TextStyle(
                                        fontFamily: 'HelveticaNeueMedium',
                                        fontSize: 20,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          'YES',
                                          style: TextStyle(
                                            fontFamily: 'HelveticaNeueMedium',
                                            fontSize: 20,
                                            color: Colors.green[800],
                                          ),
                                        ),
                                        onPressed: () {
                                          //navigation to login screen
                                        },
                                      ),
                                      FlatButton(
                                        child: Text(
                                          'NO',
                                          style: TextStyle(
                                            fontFamily: 'HelveticaNeueMedium',
                                            fontSize: 20,
                                            color: Colors.red[800],
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                            //print('logout');
                          },
                        ),
                        Text(
                          'LOGOUT',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'HelveticaNeueBold',
                            color: Colors.cyan[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      //This is the appBar which has the main heading and the drawer option
      appBar: AppBar(
        backgroundColor: Colors.cyan[800],
        title: Text(
          'Home',
          style: TextStyle(fontFamily: 'HelveticaNeueBold', fontSize: 24),
        ),
        centerTitle: true,
      ),
      //This is where the toggle option and the two cards (Map and Report Emergency) reside
      body: Center(
        child: Column(
          //everything is placed in the column
          children: <Widget>[
            Flexible(
              flex: 3,
              child: Container(
                height: height / 5,
                width: width / 1.5,
                child: Row(children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Available',
                      style: TextStyle(
                        fontFamily: 'HelveticaNeueBold',
                        fontSize: 22,
                        color: Colors.cyan[800],
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: 1.5,
                    child: Switch(
                      value: isAvailable,
                      onChanged: (bool newVal) {
                        setState(() {
                          isAvailable = newVal;
                        });
                      },
                      activeTrackColor: Colors.cyan[100],
                      activeColor: Colors.cyan[800],
                      inactiveThumbColor: Colors.white,
                    ),
                  ),
                ]),
              ),
            ),
            Flexible(
              flex: 4,
              child: SizedBox(
                height: height / 4,
                width: width / 1.5,
                child: Card(
                  elevation: 7,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.location_on,
                          color: Colors.red[400],
                          size: height / 9,
                        ),
                        onPressed: () {
                          print('Clicked');
                        },
                      ),
                      Center(
                        child: Text(
                          'Map',
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'HelveticaNeueBold',
                            color: Colors.cyan[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height / 16,
            ),
            Flexible(
              flex: 4,
              child: SizedBox(
                height: height / 4,
                width: width / 1.5,
                child: Card(
                  elevation: 7,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          icon: Image(
                            image: AssetImage('assets/report.png'),
                            fit: BoxFit.fill,
                          ),
                          iconSize: height / 9,
                          onPressed: () {
                            print('Clicked');
                          },
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, height / 80),
                            child: Text(
                              'Report Emergency',
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'HelveticaNeueBold',
                                color: Colors.cyan[800],
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
