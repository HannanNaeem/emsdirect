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
  String _rollNumber = '21100118';
  String _contact = '03362356254';
  String _email = '21100118@lums.edu.pk';

  //instance of auth service
  final AuthService _authStudent = AuthService();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return Scaffold(
      backgroundColor: const Color(0xff27496d),
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
                      fontFamily: 'HelveticaNeueLight',
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
                              fontFamily: 'HelveticaNeueLight',
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(width: 2.0),
                          Text(
                              '$_rollNumber',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeueLiight',
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
                              fontFamily: 'HelveticaNeueLight',
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(width: 2.0),
                          Text(
                            _email,
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeueLight',
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
                              fontFamily: 'HelveticaNeueLight',
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(width: 1.0),
                          Text(
                            '$_contact',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeueLight',
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
                      fontFamily: 'HelveticaNeueLight',
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
                                          fontFamily: 'HelveticaNeueLight',
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
                                              fontFamily: 'HelveticaNeueLight',
                                              letterSpacing: 3.0,
                                              fontSize: 20,
                                              color: const Color(0xff1a832a),
                                            ),
                                          ),
                                          onPressed: () async {
                                            //navigation to login screen
                                            //todo signout here                                        
                                            await _authStudent.logOut();
                                            Navigator.of(context).pop();
                                            Navigator.pushReplacementNamed(context, '/select_login');
                                            
                                          },
                                        ),
                                        FlatButton(
                                          child: Text(
                                            'NO',
                                            style: TextStyle(
                                              fontFamily: 'HelveticaNeueLight',
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
                fontSize: 24.0,
              fontFamily: 'HelveticaNeueLight',
              letterSpacing: 2.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xff142850),
        ),
        body : Center(
          child: Container(
            constraints:BoxConstraints.expand(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: height/50),
                Text(
                  'Severity Level',
                  style: TextStyle(
                      fontSize : 15.0,
                      fontFamily: 'HelveticaNeueLight',
                      color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: height /76),
                Card(
                  color: const Color(0xff00a8cc),
                  child: ToggleButtons(
                    constraints: BoxConstraints(minWidth: width/5, minHeight: height/11),
                    children: <Widget>[
                      Text(
                          "Low",
                        style: TextStyle(
                          fontFamily: 'HelveticaNeueLight',
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                          "Medium",
                        style: TextStyle(
                          fontFamily: 'HelveticaNeueLight',
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                          "High",
                        style: TextStyle(
                          fontFamily: 'HelveticaNeueLight',
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                          "Critical",
                        style: TextStyle(
                          fontFamily: 'HelveticaNeueLight',
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                    color: Colors.white,
                    selectedColor: Colors.white,
                    fillColor: Colors.redAccent,
                    borderColor: Colors.white,
                    selectedBorderColor: Colors.white,
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
                ),
                SizedBox(height: height/30),
                Text(
                  'Prefered MFR Gender',
                  style: TextStyle(
                      fontSize : 15.0,
                      color: Colors.white,
                    letterSpacing: 2.0,
                    fontFamily: 'HelveticaNeueLight',
                  ),
                ),
                SizedBox(height: height /76),
                Card(
                  color: const Color(0xff00a8cc),
                  child: ToggleButtons(
                    constraints: BoxConstraints(minWidth: width/5.5, minHeight: height/11),
                    children: <Widget>[
                      Text(
                          "N/A",
                        style: TextStyle(
                          fontFamily: 'HelveticaNeueLight',
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                          "Male",
                        style: TextStyle(
                          fontFamily: 'HelveticaNeueLight',
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                          "Female",
                        style: TextStyle(
                          fontFamily: 'HelveticaNeueLight',
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                    color: Colors.white,
                    selectedColor: Colors.white,
                    fillColor: Colors.redAccent,
                    borderColor: Colors.white,
                    selectedBorderColor: Colors.white,
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
                ),
                SizedBox(height: height/35),
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
                    constraints: BoxConstraints(minHeight: height/2.7, minWidth: height/2.7),
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
                      borderRadius: BorderRadius.circular(height/2.7),
                    )
                ),
                SizedBox(height: height/45),
                Text(
                  'TAP AND HOLD FOR 2 SECONDS',
                  style: TextStyle(
                    fontSize : 15.0,
                    color: Colors.red[400],
                    fontFamily: 'HelveticaNeueLight',
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: height/120),
                Text(
                  'INITIATE EMERGENCY',
                  style: TextStyle(
                    fontSize : 15.0,
                    color: Colors.red[400],
                    fontFamily: 'HelveticaNeueLight',
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
