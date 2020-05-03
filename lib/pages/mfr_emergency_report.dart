import 'package:flutter/material.dart';


class EmergencyReportMfr extends StatefulWidget {
  @override
  _EmergencyReportMfrState createState() => _EmergencyReportMfrState();
}

class _EmergencyReportMfrState extends State<EmergencyReportMfr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff27496d),
      appBar: AppBar(
        backgroundColor: const Color(0xff142850),
        title: Text(
          "Emergency Report",
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'HelveticaNeueLight',
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: <Widget>[
          //Emergency info card
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    //!heading
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Emergency Details',
                            style: TextStyle(
                              color: const Color(0xff142850),
                              fontFamily: "HelveticaNeueLight",
                              fontSize: 20,

                              ),
                          ),
                      ],),
                    ),

                    //! Begin form 
                ],),
              ),
            ),
          ),
        ],)
      
    );
  }
}