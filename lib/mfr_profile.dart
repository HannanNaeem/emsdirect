import 'package:flutter/material.dart';

class MfrProfile extends StatefulWidget {
  var mfr;
  MfrProfile({this.mfr});
  @override
  _MfrProfileState createState() => _MfrProfileState();
}


class _MfrProfileState extends State<MfrProfile> {
  String isHostelite(var mfr) {
    if (mfr.isHostelite == true) {
      return 'Yes';
    } else {
      return 'No';
    }
  }
  String isSenior(var mfr) {
    if (mfr.isHostelite == true) {
      return 'Yes';
    } else {
      return 'No';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff27496d),
      appBar: AppBar(
        backgroundColor: const Color(0xff142850),
        title: Text(
          'MFR Profile',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'HelveticaNeueLight',
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Name:    ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'HelveticaNeueMedium',
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    widget.mfr.name,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'HelveticaNeueLight',
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey[500],
              height: 30,
              indent: 20,
              endIndent: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Gender:    ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'HelveticaNeueMedium',
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    widget.mfr.gender,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'HelveticaNeueLight',
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey[500],
              height: 30,
              indent: 20,
              endIndent: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Roll Number:    ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'HelveticaNeueMedium',
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    widget.mfr.rollNo,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'HelveticaNeueLight',
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey[500],
              height: 30,
              indent: 20,
              endIndent: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Hostelite:    ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'HelveticaNeueMedium',
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    isHostelite(widget.mfr),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'HelveticaNeueLight',
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey[500],
              height: 30,
              indent: 20,
              endIndent: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Senior:    ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'HelveticaNeueMedium',
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    isSenior(widget.mfr),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'HelveticaNeueLight',
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey[500],
              height: 30,
              indent: 20,
              endIndent: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Contact:    ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'HelveticaNeueMedium',
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    widget.mfr.contact,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'HelveticaNeueLight',
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey[500],
              height: 30,
              indent: 20,
              endIndent: 20,
            ),
          ],
        )
      ),
    );
  }
}