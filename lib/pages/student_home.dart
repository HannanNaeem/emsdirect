import 'package:ems_direct/services/auth.dart';
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
  int _rollnumber = 21100118;
  int _contact = 03362356254;
  String _email = '21100118@lums.edu.pk';

  //instance of auth service
  final AuthService _authStudent = AuthService();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    return Scaffold(
        drawer: Container(
          width: width*0.8, //drawer covers 80% of the screen
          child: Drawer(
            child: Column(
              //this column contains the drawer header, the option to view profile/emergency numbers/available MFRs list
              //also has the option to logout
              children: <Widget>[
                DrawerHeader(
                  //only the ems logo
                  child: Container(
                    child: Image.asset("assets/ems_logo.png"),
                  ),
                ),
                ExpansionTile(
                  leading: Icon(
                      Icons.account_circle,
                  ),
                  title: Text(
                    'Harum Naseem',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'HelveticaNeue',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints(maxWidth: width*0.75),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Rollnumber:',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeue',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(width: 2.0),
                          Text(
                              '$_rollnumber',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeue',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      constraints: BoxConstraints(maxWidth: width*0.75),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Email:',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeue',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(width: 2.0),
                          Text(
                            _email,
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeue',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      constraints: BoxConstraints(maxWidth: width*0.75),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Contact:',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeue',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(width: 1.0),
                          Text(
                            '$_contact',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeue',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ListTile(
                  //the option to view emergency numbers - takes you to dummy page
                  title: Text(
                    'Emergency Numbers',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'HelveticaNeue',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/emergencyNumbers');
                    //print('Emergency numbers');
                  },
                ),
                Expanded(
                  //the option to logout (bottom center aligned)
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding:
                      EdgeInsets.fromLTRB(width * 0.8 * 0.24, 0, 0, 10.0),
                      child: Row(
                        //has the icon and text
                        children: <Widget>[
                          IconButton(
                            icon: Image(
                              image: AssetImage('assets/logout.png'),
                              fit: BoxFit.fill,
                              color: const Color(0xff3596b5),
                            ),
                            color: const Color(0xff3596b5),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "Are you sure?",
                                        style: TextStyle(
                                          fontFamily: 'HelveticaNeue',
                                          fontWeight: FontWeight.bold,
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
                                              fontFamily: 'HelveticaNeue',
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 3.0,
                                              fontSize: 20,
                                              color: const Color(0xff1a832a),
                                            ),
                                          ),
                                          onPressed: () async {
                                            //navigation to login screen
                                            //! signout here                                        
                                            await _authStudent.logOut();
                                            Navigator.of(context).pop();
                                            Navigator.pushReplacementNamed(context, '/select_login');
                                            
                                          },
                                        ),
                                        FlatButton(
                                          child: Text(
                                            'NO',
                                            style: TextStyle(
                                              fontFamily: 'HelveticaNeue',
                                              fontWeight: FontWeight.bold,
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
                                    );
                                  });
                              //print('logout');
                            },
                          ),
                          Text(
                            'LOGOUT',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'HelveticaNeueBold',
                              color: const Color(0xff3596b5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
                  constraints: BoxConstraints(maxWidth: width/1.1),
                  children: <Widget>[
                    Padding(
                      padding:  EdgeInsets.fromLTRB(22, 20, 22, 20),
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
                      padding:  EdgeInsets.fromLTRB(10, 20, 10, 20),
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
                      padding:  EdgeInsets.fromLTRB(21, 20, 21, 20),
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
                      padding:  EdgeInsets.fromLTRB(12, 20, 12, 20),
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
                  constraints: BoxConstraints(maxWidth: width/1.1),
                  children: <Widget>[
                    Padding(
                      padding:  EdgeInsets.fromLTRB(18, 20, 18, 20),
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
                      padding:  EdgeInsets.fromLTRB(17, 20, 17, 20),
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
                      padding:  EdgeInsets.fromLTRB(11, 20, 11, 20),
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
                      print(width);
                      print(height);
                    },
                    fillColor: Colors.red[400],
                    elevation: 10.0,
                    constraints: BoxConstraints(minHeight: width/1.8, minWidth: width/1.8),
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
                      borderRadius: BorderRadius.circular(width/1.8),
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
