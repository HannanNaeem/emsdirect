import 'package:flutter/material.dart';

// Displays the select login screen - user chooses which user he/she wants to login as

class SelectLogin extends StatefulWidget {
  @override
  SelectLoginScreenState createState() => new SelectLoginScreenState();
}

class SelectLoginScreenState extends State<SelectLogin> {
  @override
  Widget build(BuildContext context) {
    // Used to make screen responsive.
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [const Color(0xff00a8cc), const Color(0xff142850)],
              ),
            ),
            child: new SingleChildScrollView(
              child: Center(
                  child: Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          width * 0.28, height * 0.1, width * 0.28, height * 0.05),
                      child: Image.asset('assets/ems_logo.png',
                          scale: 0.0009 * (height + width)),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          width * 0.16, height * 0.01, width * 0.16, 10.0),
                      child: Text(
                        'LOGIN AS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: (width + height) * 0.02,
                          letterSpacing: 8.0,
                          fontFamily: 'HelveticaNeueLight',
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            width * 0.16, height * 0.05, width * 0.16, 10.0),
                        child: SizedBox(
                            width: (width + height) * 0.15,
                            height: (width + height) * 0.04,
                            child: RaisedButton(
                                onPressed: () {
                                  // Navigating to student login screen
                                  Navigator.pushNamed((context), '/login_student');
                                },
                                textColor: Colors.cyan[500],
                                color: Colors.white,
                                child: Text(
                                  'STUDENT',
                                  style: TextStyle(
                                    color: Colors.cyan[500],
                                    fontSize: (width + height) * 0.012,
                                    letterSpacing: 3.0,
                                    fontFamily: 'HelveticaNeueBold',
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            width * 0.16, height * 0.05, width * 0.16, 10.0),
                        child: SizedBox(
                            width: (width + height) * 0.15,
                            height: (width + height) * 0.04,
                            child: RaisedButton(
                                onPressed: () {
                                  // Navigating to OPS login screen
                                  Navigator.pushNamed(context, '/login_ems_ops');
                                }, //add later
                                textColor: Colors.cyan[500],
                                color: Colors.white,
                                child: Text(
                                  'OPS',
                                  style: TextStyle(
                                    color: Colors.cyan[500],
                                    fontSize: (width + height) * 0.012,
                                    letterSpacing: 3.0,
                                    fontFamily: 'HelveticaNeueBold',
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            width * 0.16, height * 0.05, width * 0.16, 10.0),
                        child: SizedBox(
                            width: (width + height) * 0.15,
                            height: (width + height) * 0.04,
                            child: RaisedButton(
                                onPressed: () {
                                  // Navigating to MFR login screen
                                  Navigator.pushNamed(context, '/login_ems_mfr');
                                }, //add later
                                textColor: Colors.cyan[500],
                                color: Colors.white,
                                child: Text(
                                  'MFR',
                                  style: TextStyle(
                                    color: Colors.cyan[500],
                                    fontSize: (width + height) * 0.012,
                                    letterSpacing: 3.0,
                                    fontFamily: 'HelveticaNeueBold',
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )))),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          width * 0.16, height * 0.06, width * 0.16, 10.0),
                      child: Text(
                        'EMS DIRECT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: (width + height) * 0.01,
                          letterSpacing: 5.0,
                          fontFamily: 'HelveticaNeueLight',
                        ),
                      ),
                    ),
              ])),
            )));
  }
}
