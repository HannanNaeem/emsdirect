import 'package:flutter/material.dart';
import 'package:ems_direct/presentation/custom_icons.dart' as CustomIcons;

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
    if (mfr.isSenior == true) {
      return 'Yes';
    } else {
      return 'No';
    }
  }

  String gender(var mfr) {
    if (mfr.gender == 'F') {
      return 'Female';
    } else if (mfr.gender == 'M') {
      return 'Male';
    } else {
      return 'NA';
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    final height = screenSize.height;

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            color: const Color(0xff142850),
            height: height * 0.4,
            //width: width,
            child: Stack(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SafeArea(
                  child: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Center(
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/ems_logo.png'),
                        backgroundColor: Colors.transparent,
                      ),
                      SizedBox(height: 20),
                      Text(
                        widget.mfr.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'HelveticaNeueLight',
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //SizedBox(height: 20),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 20),
            child: Text(
              'Profile Info',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'HelveticaNeueLight',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 2,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 20),
            child: Row(
              children: <Widget>[
                Icon(
                  CustomIcons.MyFlutterApp.wc,
                  color: const Color(0xff142850),
                ),
                SizedBox(width: 10),
                Text(
                  'Gender: ',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'HelveticaNeueLight',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  gender(widget.mfr),
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'HelveticaNeueLight',
                    color: Colors.black,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 20),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.email,
                  color: const Color(0xff142850),
                ),
                SizedBox(width: 10),
                Text(
                  'Email: ',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'HelveticaNeueLight',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  '${widget.mfr.rollNo}@lums.edu.pk',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'HelveticaNeueLight',
                    color: Colors.black,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 20),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.call,
                  color: const Color(0xff142850),
                ),
                SizedBox(width: 10),
                Text(
                  'Contact: ',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'HelveticaNeueLight',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  widget.mfr.contact,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'HelveticaNeueLight',
                    color: Colors.black,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}

//          Padding(
//            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
//            child: Row(
//              children: <Widget>[
//                Text(
//                  'Name:    ',
//                  style: TextStyle(
//                    fontSize: 18,
//                    color: Colors.white,
//                    fontFamily: 'HelveticaNeueMedium',
//                    letterSpacing: 1.0,
//                  ),
//                ),
//                Text(
//                  widget.mfr.name,
//                  style: TextStyle(
//                    fontSize: 18,
//                    color: Colors.white,
//                    fontFamily: 'HelveticaNeueLight',
//                    letterSpacing: 2.0,
//                  ),
//                ),
//              ],
//            ),
//          ),
//          Divider(
//            color: Colors.grey[500],
//            height: 30,
//            indent: 20,
//            endIndent: 20,
//          ),
//          Padding(
//            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
//            child: Row(
//              children: <Widget>[
//                Text(
//                  'Gender:    ',
//                  style: TextStyle(
//                    fontSize: 18,
//                    color: Colors.white,
//                    fontFamily: 'HelveticaNeueMedium',
//                    letterSpacing: 1.0,
//                  ),
//                ),
//                Text(
//                  widget.mfr.gender,
//                  style: TextStyle(
//                    fontSize: 18,
//                    color: Colors.white,
//                    fontFamily: 'HelveticaNeueLight',
//                    letterSpacing: 2.0,
//                  ),
//                ),
//              ],
//            ),
//          ),
//          Divider(
//            color: Colors.grey[500],
//            height: 30,
//            indent: 20,
//            endIndent: 20,
//          ),
//          Padding(
//            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
//            child: Row(
//              children: <Widget>[
//                Text(
//                  'Roll Number:    ',
//                  style: TextStyle(
//                    fontSize: 18,
//                    color: Colors.white,
//                    fontFamily: 'HelveticaNeueMedium',
//                    letterSpacing: 1.0,
//                  ),
//                ),
//                Text(
//                  widget.mfr.rollNo,
//                  style: TextStyle(
//                    fontSize: 18,
//                    color: Colors.white,
//                    fontFamily: 'HelveticaNeueLight',
//                    letterSpacing: 2.0,
//                  ),
//                ),
//              ],
//            ),
//          ),
//          Divider(
//            color: Colors.grey[500],
//            height: 30,
//            indent: 20,
//            endIndent: 20,
//          ),
//          Padding(
//            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
//            child: Row(
//              children: <Widget>[
//                Text(
//                  'Hostelite:    ',
//                  style: TextStyle(
//                    fontSize: 18,
//                    color: Colors.white,
//                    fontFamily: 'HelveticaNeueMedium',
//                    letterSpacing: 1.0,
//                  ),
//                ),
//                Text(
//                  isHostelite(widget.mfr),
//                  style: TextStyle(
//                    fontSize: 18,
//                    color: Colors.white,
//                    fontFamily: 'HelveticaNeueLight',
//                    letterSpacing: 2.0,
//                  ),
//                ),
//              ],
//            ),
//          ),
//          Divider(
//            color: Colors.grey[500],
//            height: 30,
//            indent: 20,
//            endIndent: 20,
//          ),
//          Padding(
//            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
//            child: Row(
//              children: <Widget>[
//                Text(
//                  'Senior:    ',
//                  style: TextStyle(
//                    fontSize: 18,
//                    color: Colors.white,
//                    fontFamily: 'HelveticaNeueMedium',
//                    letterSpacing: 1.0,
//                  ),
//                ),
//                Text(
//                  isSenior(widget.mfr),
//                  style: TextStyle(
//                    fontSize: 18,
//                    color: Colors.white,
//                    fontFamily: 'HelveticaNeueLight',
//                    letterSpacing: 2.0,
//                  ),
//                ),
//              ],
//            ),
//          ),
//          Divider(
//            color: Colors.grey[500],
//            height: 30,
//            indent: 20,
//            endIndent: 20,
//          ),
//          Padding(
//            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
//            child: Row(
//              children: <Widget>[
//                Text(
//                  'Contact:    ',
//                  style: TextStyle(
//                    fontSize: 18,
//                    color: Colors.white,
//                    fontFamily: 'HelveticaNeueMedium',
//                    letterSpacing: 1.0,
//                  ),
//                ),
//                Text(
//                  widget.mfr.contact,
//                  style: TextStyle(
//                    fontSize: 18,
//                    color: Colors.white,
//                    fontFamily: 'HelveticaNeueLight',
//                    letterSpacing: 2.0,
//                  ),
//                ),
//              ],
//            ),
//          ),
//          Divider(
//            color: Colors.grey[500],
//            height: 30,
//            indent: 20,
//            endIndent: 20,
//          ),
