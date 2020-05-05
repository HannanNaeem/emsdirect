import 'dart:async';
import 'package:ems_direct/pages/auth_wrapper.dart';
import 'package:flutter/material.dart';

// Displays the splash screen in the beginning of the app.

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    // Setting splash display time to 2
    Timer(
        Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return Wrapper();
            })));
  }

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
                          width * 0.23, height * 0.20, width * 0.23, height * 0.05),
                      child: Image.asset('assets/ems_logo.png',
                          scale: 0.0010 * (height + width)),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          width * 0.16, height * 0.06, width * 0.16, 10.0),
                      child: Text(
                        'EMS DIRECT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: (width + height) * 0.02,
                          letterSpacing: 8.0,
                          fontFamily: 'HelveticaNeueLight',
                        ),
                      ),
                    ),
                  ]),
                ))));
  }
}
