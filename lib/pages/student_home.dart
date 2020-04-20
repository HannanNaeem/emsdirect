import 'package:flutter/material.dart';

class StudentHome extends StatefulWidget {
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  List<bool> _selections = List.generate(4, (_) => false);
  List<bool> _selections2 = List.generate(3, (_) => false);
  int _gender = 0;
  int _severityLevel = 0;
  bool _emergency = false;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    return Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          title: Text(
            'Home',
            style: TextStyle(
                fontSize: 28.0,
              fontFamily: 'HelveticaNeue',
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.cyan[800],
        ),
        body : Padding(
          padding: EdgeInsets.fromLTRB(1.0, height/30, 1.0, 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Severity Level',
                  style: TextStyle(
                      fontSize : 15.0,
                      fontFamily: 'HelveticaNeue',
                      color: Colors.cyan[800],
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                ToggleButtons(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
                      child: Text(
                          "Low",
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                      child: Text(
                          "Medium",
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(21, 20, 21, 20),
                      child: Text(
                          "High",
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
                      child: Text(
                          "Critical",
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  color: Colors.cyan[600],
                  selectedColor: Colors.white,
                  fillColor: Colors.cyan[700],
                  isSelected: _selections,
                  onPressed: (int index){
                    setState((){
                      for(int buttonIndex = 0; buttonIndex < _selections.length; buttonIndex++){
                        if(buttonIndex == index){
                          _selections[buttonIndex] = true;
                        } else{
                          _selections[buttonIndex] = false;
                        }
                        _severityLevel = index;
                      }
                      print(_severityLevel);
                    });
                  },
                ),
                SizedBox(height: 20.0),
                Text(
                  'Prefered MFR Gender',
                  style: TextStyle(
                      fontSize : 15.0,
                      color: Colors.cyan[800],
                    letterSpacing: 2.0,
                    fontFamily: 'HelveticaNeue',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                ToggleButtons(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
                      child: Text(
                          "N/A",
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(17, 20, 17, 20),
                      child: Text(
                          "Male",
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(11, 20, 11, 20),
                      child: Text(
                          "Female",
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  color: Colors.cyan[600],
                  selectedColor: Colors.white,
                  fillColor: Colors.cyan[700],
                  isSelected: _selections2,
                  onPressed: (int index){
                    setState((){
                      for(int buttonIndex = 0; buttonIndex < _selections2.length; buttonIndex++){
                        if(buttonIndex == index){
                          _selections2[buttonIndex] = true;
                        } else{
                          _selections2[buttonIndex] = false;
                        }
                        _gender = index;
                      }
                      print(_gender);
                    });
                  },
                ),
                SizedBox(height: 20.0),
                RawMaterialButton(
                  onPressed: (){
                    setState(() {
                      _emergency = true;
                    });
                  },
                    onLongPress: () {
                      Navigator.of(context).pushNamed('/live_status');
                      print("emergency initiated");
                    },
                    fillColor: Colors.red[400],
                    elevation: 10.0,
                    constraints: BoxConstraints(minHeight: 200, minWidth: 200),
                    child: Text(
                      'SOS',
                      style: TextStyle(
                        fontSize: 70.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'HelveticaNeue',
                        letterSpacing: 2.0,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(200),
                    )
                ),
                SizedBox(height: 10),
                Text(
                  'TAP AND HOLD FOR 2 SECONDS',
                  style: TextStyle(
                    fontSize : 15.0,
                    color: Colors.red[400],
                    fontWeight: FontWeight.bold,
                    fontFamily: 'HelveticaNeue',
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 3.0),
                Text(
                  'INITIATE EMERGENCY',
                  style: TextStyle(
                    fontSize : 15.0,
                    color: Colors.red[400],
                    fontFamily: 'HelveticaNeue',
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
