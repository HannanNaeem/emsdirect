import 'package:flutter/material.dart';

class MfrListCard extends StatefulWidget {
  String name;
  String contact;
  String rollNo;
  String gender;
  bool isOccupied;


  MfrListCard(var mfr) {
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
    );
  }
}



class MfrListData {

  static final data = [
    {
      'name': 'Hira Jamshed',
      'rollNo': '21100141',
    },
    {
      'name': 'Harum Naseem',
      'rollNo': '21100118',
    },
    {
      'name': 'Hannan Naeem',
      'rollNo': '21100219',
    },
    {
      'name': 'Mahnoor Jameel',
      'rollNo': '21100069',
    },
    {
      'name': 'Saba Rehman',
      'rollNo': '21100129',
    },
  ];
}

