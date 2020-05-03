import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ems_direct/models/emergency_models.dart';
class MfrInformation extends StatefulWidget {
  String name;
  String rollNo;
  String contact;
  bool isSenior;
  String gender;

  MfrInformation(String mfrName, String mfrRollNo ,String mfrContact, String Gender, bool IsSenior) {
    this.name = mfrName;
    this.rollNo = mfrRollNo;
    this.contact = mfrContact;
    this.gender = Gender;
    this.isSenior = IsSenior;
  }

  @override
  _MfrInformationState createState() => _MfrInformationState();
}


class _MfrInformationState extends State<MfrInformation> {
  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return CupertinoButton(
      child: Container(
        height: 0.15*height,
        width: 0.9*width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Container(

          margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Column(
          children: <Widget>[
            Text(
              'MFR: ' + widget.name + ' ' + widget.rollNo,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xff142850),
                fontSize: 14,
                fontFamily: 'HelveticaNeueLight',
                letterSpacing: 1,
              ),
            ),
            Text(
              'Contact: ' + widget.contact,
                textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xff142850),
                fontSize: 14,
                fontFamily: 'HelveticaNeueLight',
                letterSpacing: 1,
              ),
            ),
            Text(
              'Gender: ' + widget.gender,
                textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xff142850),
                fontSize: 14,
                fontFamily: 'HelveticaNeueLight',
                letterSpacing: 1,
              ),
            ),
            Text(
              'Senior: ' + widget.isSenior.toString(),
                textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xff142850),
                fontSize: 14,
                fontFamily: 'HelveticaNeueLight',
                letterSpacing: 1,
              ),
            ),
          ]
        ),
      ),

    ),
      onPressed: () {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) =>
              AlertDialog(
                title: Text(
                  "Do you want to assign this MFR?",
                  style: TextStyle(
                    fontFamily: 'HelveticaNeueLight',
                    letterSpacing: 2.0,
                    fontSize: 20,
                    color: Colors.grey[600],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'YES',
                      style: TextStyle(
                        fontFamily: 'HelveticaNeueLight',
                        letterSpacing: 3.0,
                        fontSize: 20,
                        color: const Color(0xff1a832a),
                      ),
                    ),
                    onPressed: () {
                      //todo: assign MFR
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'NO',
                      style: TextStyle(
                        fontFamily: 'HelveticaNeueLight',
                        letterSpacing: 2.5,
                        fontSize: 20,
                        color: const Color(0xffee0000),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
        );
      },
    );
  }
}
