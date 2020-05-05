import 'package:flutter/material.dart';

class SeniorMfrCard extends StatefulWidget {
  String name;
  String contact;
  String rollNo;
  String gender;
  bool isOccupied;


  SeniorMfrCard(String name, String contact, String rollNo, String gender, bool isOccupied) {
    this.name = name;
    this.contact = contact;
    this.rollNo = rollNo;
    this.gender = gender;
    this.isOccupied = isOccupied;
  }

  @override
  _SeniorMfrCardState createState() => _SeniorMfrCardState();
}

class _SeniorMfrCardState extends State<SeniorMfrCard> {

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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

