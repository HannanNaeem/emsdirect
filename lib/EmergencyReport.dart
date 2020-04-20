import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';


class EmergencyReport extends StatefulWidget {
  @override
  _EmergencyReportState createState() => new _EmergencyReportState();
}

class _EmergencyReportState extends State<EmergencyReport> {
//  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
//  List<String> _colors = <String>['', 'red', 'green', 'blue', 'orange'];
//  String _color = '';
  List<bool> isSelected = [false, false, false];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          backgroundColor: Colors.cyan[800],
          title: Align(
              alignment: Alignment(-0.3,0),
              child: new Text('Emergency Report')),
          leading: IconButton(
            icon:Icon(Icons.arrow_back),
            onPressed:() => Navigator.pop(context, false),
          ),
      ),

      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
//                  Align(
//                    alignment: Alignment(-1.0, 0.0),
//                    child: Text (
//                      "\nRoll Number:",
//                      style: TextStyle(
//                        color: Colors.cyan[800],
//                        fontSize: 18.0,
//                        fontFamily: 'HelveticalNeueBold',
//                      ),
//                    ),
//                  ),
                  new TextFormField(
                    decoration: new InputDecoration(
                        labelText: "Roll Number",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ) ,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ) ,
                        border: UnderlineInputBorder(
                        )
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                  ),
                  Align(
                    alignment: Alignment(-1.0, 0.0),
                    child: Text (
                      "\nGender:\n",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18.0,
                        fontFamily: 'HelveticalNeueBold',
                      ),
                    ),
                  ),
                  ToggleButtons(
                    color: Colors.cyan[500], // sets the color of its children when its not selected
                    selectedColor: Colors.white, // sets the color of its children when its selected
                    fillColor: Colors.white, // sets the color of button when selected
                    highlightColor: Colors.cyan[500],
                    children: <Widget> [
                      Text('Male'),
                      Text('Female'),
                    ],
                    isSelected: isSelected,
                    onPressed: (int index){
                      setState(){
                        isSelected[index] = !isSelected[index];
                      }
                    },
                  ),

                ]
              ),

          )
      )
    );
  }
}