import 'package:flutter/material.dart';
import 'package:ems_direct/mfr_profile.dart';


class MfrListCard extends StatefulWidget {
  String name;
  String contact;
  String rollNo;
  String gender;
  var mfr;


  MfrListCard(var mfr) {
    this.mfr = mfr;
    this.name = mfr.name;
    this.rollNo = mfr.rollNo;
  }

  @override
  _MfrListCardState createState() => _MfrListCardState();
}

class _MfrListCardState extends State<MfrListCard> {

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: InkWell(
        onTap: () {
          Navigator.push(context,
          MaterialPageRoute(builder: (context) => MfrProfile(mfr: widget.mfr)));
        },
        child: ListTile(
          title: Center(
            child: Text(
              widget.name.toUpperCase(),
              style: TextStyle(
                letterSpacing: 2.0,
                fontFamily: 'HelveticaNeueMedium',
              )
            ),
          ),
          subtitle: Center(
            child: Text(
              widget.rollNo,
              style: TextStyle(
                letterSpacing: 1.0,
                fontFamily: 'HelveticaNeueMedium',
              )
            ),
          ),
        ),
      ),
    );
  }
}


