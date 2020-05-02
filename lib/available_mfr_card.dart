import 'package:flutter/material.dart';

class AvailableMfrCard extends StatefulWidget {
  String name;
  String contact;
  String rollNo;
  String gender;
  bool isOccupied;


  AvailableMfrCard(String name, String contact, String rollNo, String gender, bool isOccupied) {
    this.name = name;
    this.contact = contact;
    this.rollNo = rollNo;
    this.gender = gender;
    this.isOccupied = isOccupied;
  }

  @override
  _AvailableMfrCardState createState() => _AvailableMfrCardState();
}

class _AvailableMfrCardState extends State<AvailableMfrCard> {

  @override
  Widget build(BuildContext context) {
    Color GenerateColor(bool isOccupied)
    {
      if(isOccupied){
        return Colors.red[800];
      } else {
        return Colors.blue[800];
      }
    }
    return Card(
      elevation: 6,
      child: ListTile(
        isThreeLine: true,
        leading: Icon(
          Icons.fiber_manual_record,
          color: GenerateColor(widget.isOccupied)
        ),
        title: Text(
          widget.name,
          style: TextStyle(
            letterSpacing: 2.0,
            fontFamily: 'HelveticaNeueLight',
          )
        ),
        subtitle: Text(
          "Contact: " + widget.contact + "\n" +
          "Roll Number: " + widget.rollNo + "\n" + 
          "Gender: " + widget.gender,
          style: TextStyle(
            letterSpacing: 1.0,
            fontFamily: 'HelveticaNeueLight',
          )
        ),
      ),
    );
  }
}



class AvailableMfrsData {

  static final data = [
    {
      'name': 'Hira Jamshed',
      'contact': '03000000000',
      'gender': 'F',
      'rollNo': '21100141',
      'isOccupied': true,
    },
    {
      'name': 'Harum Naseem',
      'contact': '03000000000',
      'gender': 'F',
      'rollNo': '21100118',
      'isOccupied': false,
    },
    {
      'name': 'Hannan Naeem',
      'contact': '03000000000',
      'gender': 'M',
      'rollNo': '21100219',
      'isOccupied': false,
    },
    {
      'name': 'Mahnoor Jameel',
      'contact': '03000000000',
      'gender': 'F',
      'rollNo': '21100069',
      'isOccupied': true,
    },
    {
      'name': 'Saba Rehman',
      'contact': '03000000000',
      'gender': 'F',
      'rollNo': '21100129',
      'isOccupied': false,
    },
  ];
}

