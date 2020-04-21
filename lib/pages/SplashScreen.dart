import 'dart:async';
import 'package:flutter/material.dart';
//import 'main.dart';
import "package:ems_direct/pages/SelectLogin.dart";
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds:2),
            () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                  builder : (BuildContext context) => SelectLogin()
            )
            )
    );
  }

  @override
  Widget build( BuildContext context ) {
    return Scaffold(
      backgroundColor: Colors.transparent,
        body: Container(
        constraints:BoxConstraints.expand(),
        decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [const Color(0xff00a8cc),const Color(0xff142850) ],
                  
                  
                  ),
          ),
          
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment(0,-0.3),
                child: Image.asset(
                 'assets/ems_logo.png',
                  scale: 2.3,
                ),
              ),
              Align(
                alignment: Alignment(0,0.4),
                  child: Text(
                    'EMS DIRECT',
                    style: TextStyle(
                      color:Colors.white,
                      fontSize: 24.0,
                      letterSpacing: 8.0,
                      fontFamily: 'HelveticaNeueLight',
                    ),
                  ),
              ),
            ]
          ),
        )
    );
  }
}



