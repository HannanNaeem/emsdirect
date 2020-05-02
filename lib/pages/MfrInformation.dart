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
        height: 0.02*height,
        width: 0.01*width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(

          margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
          child: Column(
          children: <Widget>[
            Text(
              'MFR: ' + widget.name + ' ' + widget.rollNo,
              style: TextStyle(
                color: const Color(0xff142850),
                fontSize: 14,
                fontFamily: 'HelveticaNeueLight',
                letterSpacing: 1,
              ),
            ),
            Text(
              'Contact: ' + widget.contact,
              style: TextStyle(
                color: const Color(0xff142850),
                fontSize: 14,
                fontFamily: 'HelveticaNeueLight',
                letterSpacing: 1,
              ),
            ),
            Text(
              'Gender: ' + widget.gender,
              style: TextStyle(
                color: const Color(0xff142850),
                fontSize: 14,
                fontFamily: 'HelveticaNeueLight',
                letterSpacing: 1,
              ),
            ),
            Text(
              'Senior: ' + widget.isSenior.toString(),
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
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: const Text('Do you want to assign this MFR?'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  // todo: assign MFR here
                },
              ),
              CupertinoDialogAction(
                child: const Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
