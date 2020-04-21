import 'package:flutter/material.dart';

class SelectLogin extends StatefulWidget {
  @override
  _SelectLoginScreenState createState() => new _SelectLoginScreenState();
}

class _SelectLoginScreenState extends State<SelectLogin> {
  @override
  Widget build(BuildContext context) {
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
                  alignment: Alignment(0,-0.75),
                  child: Image.asset(
                      'assets/ems_logo.png',
                      scale: 3.2,
                  ),
                ),
                Align(
                  alignment: Alignment(0,-0.13),
                  child: Text(
                    'LOGIN AS',
                    style: TextStyle(
                      color:Colors.white,
                      fontSize: 24.0,
                      letterSpacing: 8.0,
                      fontFamily: 'HelveticaNeueLight',
                    ),

                  ),
                ),
                
                Align(
                    alignment: Alignment(0, 0.1),
                    child: SizedBox (
                        width: 180,
                        height: 45,
                        child: RaisedButton(
                            onPressed: () {
                              Navigator.pushNamed((context), '/login_student');
                            }, 
                            textColor: Colors.cyan[500],
                            color: Colors.white,
                            child: Text(
                              'STUDENT',
                              style: TextStyle(
                                color:Colors.cyan[500],
                                fontSize: 16.0,
                                letterSpacing: 3.0,
                                fontFamily: 'HelveticaNeueBold',
                              ),

                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            )
                        )
                    )
                ),
                Align(
                    alignment: Alignment(0, 0.3),
                    child: SizedBox (
                        width: 180,
                        height: 45,
                        child: RaisedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login_ems');
                            }, //add later
                            textColor: Colors.cyan[500],
                            color: Colors.white,
                            child: Text(
                              'OPS',
                              style: TextStyle(
                                color:Colors.cyan[500],
                                fontSize: 16.0,
                                letterSpacing: 3.0,
                                fontFamily: 'HelveticaNeueBold',
                              ),

                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            )
                        )
                    )
                ),
                Align(
                    alignment: Alignment(0, 0.5),
                    child: SizedBox (
                        width: 180,
                        height: 45,
                        child: RaisedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login_ems');
                            }, //add later
                            textColor: Colors.cyan[500],
                            color: Colors.white,
                            child: Text(
                              'MFR',
                              style: TextStyle(
                                color:Colors.cyan[500],
                                fontSize: 16.0,
                                letterSpacing: 3.0,
                                fontFamily: 'HelveticaNeueBold',
                              ),

                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            )
                        )
                    )
                ),
                Align(
                  alignment: Alignment(0, 0.9),
                  child: Text(
                    'EMS DIRECT',
                    style: TextStyle(
                      color:Colors.white,
                      fontSize: 15.0,
                      letterSpacing: 5.0,
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


