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

          child: Center(
          child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(width*0.35, height*0.12,width*0.35, height*0.05),
                  child: Image.asset(
                      'assets/ems_logo.png',
                      scale: 0.0009*(height+width)
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(width*0.16, height*0.03, width*0.16, 10.0),
                  child: Text(
                    'LOGIN AS',
                    style: TextStyle(
                      color:Colors.white,
                      fontSize: (width)*0.04,
                      letterSpacing: 8.0,
                      fontFamily: 'HelveticaNeueLight',
                    ),
                  ),
                ),

                Padding(
                    padding: EdgeInsets.fromLTRB(width*0.16, height*0.05, width*0.16, 10.0),
                    child: SizedBox (
                        width: width*0.35,
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
                                fontSize: (width)*0.03,
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
                    padding: EdgeInsets.fromLTRB(width*0.16, height*0.05, width*0.16, 10.0),
                    child: SizedBox (
                        width: width*0.35,
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
                                fontSize: (width)*0.03,
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
                    padding: EdgeInsets.fromLTRB(width*0.16, height*0.05, width*0.16, 10.0),
                    child: SizedBox (
                        width: width*0.35,
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
                                fontSize: (width)*0.03,
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
                  padding: EdgeInsets.fromLTRB(width*0.16, height*0.11, width*0.16, 10.0),
                  child: Text(
                    'EMS DIRECT',
                    style: TextStyle(
                      color:Colors.white,
                      fontSize: (width)*0.02,
                      letterSpacing: 5.0,
                      fontFamily: 'HelveticaNeueLight',
                    ),

                  ),
                ),
              ]
          )
          ),
        )
    );
  }
}


