import 'package:flutter/material.dart';

class SelectLogin extends StatefulWidget {
  @override
  _SelectLoginScreenState createState() => new _SelectLoginScreenState();
}

class _SelectLoginScreenState extends State<SelectLogin> {
  @override

  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
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
                Padding(
                  padding: EdgeInsets.fromLTRB(width  * 0.27, 100.0, 10.0, height*0.2),
                  child: Image.asset(
                      'assets/ems_logo.png',
                      scale: 0.009*width,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(width  * 0.27, 320.0, 10.0, height*0.2),
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

                Padding(
                    padding: EdgeInsets.fromLTRB(width  * 0.245, 400.0, 10.0, height*0.2),
                    child: SizedBox (
                        width: width*0.50,
                        height: height*0.06,
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
                Padding(
                    padding: EdgeInsets.fromLTRB(width  * 0.25, 475.0, 10.0, height*0.2),
                    child: SizedBox (
                        width: width*0.50,
                        height: height*0.06,
                        child: RaisedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login_ems_ops');
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
                Padding(
                    padding: EdgeInsets.fromLTRB(width  * 0.245, 550.0, 10.0, height*0.2),
                    child: SizedBox (
                        width: width*0.50,
                        height: height*0.06,
                        child: RaisedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login_ems_mfr');
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


