import 'package:ems_direct/models/emergency_models.dart';
import 'package:ems_direct/services/auth.dart';
import 'package:ems_direct/services/mfr_database.dart';
import 'package:ems_direct/services/ops_database.dart';
import 'package:ems_direct/services/ops_notification_wrapper.dart';
import 'package:ems_direct/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/mfr_home_wrapper.dart';
import 'package:provider/provider.dart';

//-----------------------------
// Ems Login Logic + screen
//-----------------------------


class LoginEms extends StatefulWidget {
  String _emsType = '';

  LoginEms(String emsType) {
    _emsType = emsType;
  }

  @override
  _LoginEmsState createState() => _LoginEmsState(_emsType);
}

class _LoginEmsState extends State<LoginEms> {
  String _emsType;

  _LoginEmsState(String emsType) {
    _emsType = emsType;
  }

  bool _loading = false; //to detect if we need to show loading screen
  String _email;
  String _password;
  bool _keepSignedIn = false; 

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // Auth service defined in auth.dart to communicate and perform auth functions
  final AuthService _authEms = AuthService();


  //! Build email textfield
  Widget _buildEmail() {
  

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextFormField(
          decoration: InputDecoration(
            hintText: 'Email Address',
            hintStyle: TextStyle(
              color: Colors.grey[700],
              fontFamily: 'HelveticaNeueLight',
              letterSpacing: 2.0,
            ),
            errorStyle: TextStyle(
              color: Colors.amber,
              letterSpacing: 1.0,
            ),
            fillColor: Colors.grey[200],
            filled: true,
            focusedErrorBorder: InputBorder.none,
          ),
          validator: (String value) {
            if (value.isEmpty) return 'Email is required!';

            if (!RegExp(
                    r"^[a-zA-Z0-9_.+-]+@(?:(?:[a-zA-Z0-9-]+\.)?[a-zA-Z]+\.)?(lums.edu)\.pk$")
                .hasMatch(value)) {
              return 'Please enter a LUMS email address';
            }
          },
          onSaved: (String value) {
            _email = value;
          }),
    );
  }
  //! build password text field
  Widget _buildPassword() {

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextFormField(
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(
              color: Colors.grey[700],
              fontFamily: 'HelveticaNeueLight',
              letterSpacing: 2.0,
            ),
            errorStyle: TextStyle(
              color: Colors.amber,
              letterSpacing: 1.0,
            ),
            fillColor: Colors.grey[200],
            filled: true,
            focusedErrorBorder: InputBorder.none,
          ),
          validator: (String value) {
            if (value.isEmpty) return 'Password is required!';
          },
          onSaved: (String value) {
            _password = value;
          }),
    );
  }
  //! build keep me signed in check box
  Widget _buildKeepSignedIn() {
    return Row(children: <Widget>[
      Checkbox(
        value: _keepSignedIn,
        tristate: false,
        checkColor: Colors.grey[800],
        activeColor: Colors.grey[300],
        onChanged: (bool newValue) {
          setState(() {
            _keepSignedIn = newValue;
          });
        },
      ),
      Text(
        'Keep me signed in',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ]);
  }
  //! Put together all text fields and build a form
  Widget _buildForm(final height) {
    return Container(
      height: 355,
      child: Form(
        key: _formKey,
        child: Column(
          //main axis allignment here
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            SizedBox(height: 40),
            _buildEmail(),
            SizedBox(height: 30),
            _buildPassword(),
            SizedBox(height: 10),
            _buildKeepSignedIn(),
            SizedBox(height: 30),
            ButtonTheme(
              height: height / 14,
              minWidth: height / 5,
              child: RaisedButton(
                onPressed: () async {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }

                  _formKey.currentState.save();

                  setState(() {
                    _loading = true;  // Loading is triggered as await is about to be called
                  });

                  // login = wait for result meanwhile show the loading screen
                  dynamic result =
                      await _authEms.signIn(_email, _password, _emsType);

                  //! TESTING -----------------------------------------
                  // print(_email);
                  // print(_password);
                  // print(_keepSignedIn);

                  if (result == null) {
                    setState(() {
                      _loading = false;
                    });
                    // Login has failed show an error dialog
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Invalid login",
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
                                  'TRY AGAIN',
                                  style: TextStyle(
                                    fontFamily: 'HelveticaNeueLight',
                                    letterSpacing: 2.5,
                                    fontSize: 16,
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

                    //print("Error signing in!");
                  } else {
                    //print("User signed in!");
                    
                    // Login was successful - Take to the home screen
                    Navigator.pop(context);
                    if (_emsType == 'ops') { // if selected user is ops
                      Navigator.pushReplacement(
                          context,
                          // NAfigate but set the proper providers for data streams
                          MaterialPageRoute(
                              builder: (context) => StreamProvider<
                                      List<OngoingEmergencyModel>>.value(
                                  value: OpsDatabaseService().onGoingStream,
                                  child: StreamProvider<
                                          List<AvailableMfrs>>.value(
                                      value: OpsDatabaseService()
                                          .availableMfrStream,
                                      child: StreamProvider<
                                              List<SevereEmergencyModel>>.value(
                                          value:
                                              OpsDatabaseService().severeStream,
                                          child: StreamProvider<
                                              List<
                                                  DeclinedEmergencyModel>>.value(
                                            value: OpsDatabaseService()
                                                .declinedStream,
                                            child: OpsWrapper(
                                                _keepSignedIn, result),
                                          ))))));
                    } else if (_emsType == 'mfr') { // if selected user is mfr
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StreamProvider<
                                      List<PendingEmergencyModel>>.value(
                                    value: MfrDatabaseService().pendingStream,
                                    child: StreamProvider<
                                            List<OngoingEmergencyModel>>.value(
                                        value:
                                            MfrDatabaseService().ongoingStream,
                                        child:
                                            MfrWrapper(_keepSignedIn, result)),
                                  )));
                    }
                  }
                },
                child: Text('LOGIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'HelveticaNeueBold',
                      letterSpacing: 3.0,
                    )),
                color: const Color(0xFF73CDE8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final height = screenSize.height;


    // The Overall widget tree
    return _loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: const Color(0xff142850),
              elevation: 0.0,
            ),
            body: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [const Color(0xff00a8cc), const Color(0xff142850)],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.fromLTRB(height / 30, 0, height / 30, 0),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'assets/ems_logo.png',
                            scale: (height / 100) / 2,
                          ),
                          SizedBox(height: height / 40),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, height / 30, 0, 0),
                            child: Text(
                              'EMS LOGIN',
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 6.0,
                                fontFamily: 'HelveticaNeueLight',
                                fontSize: 24,
                              ),
                            ),
                          ),
                          SizedBox(height: height / 40),
                          _buildForm(height),
                          SizedBox(
                            height: height / 50,
                          ),
                          // Expanded(child: Container(),),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(0, 20, 0, height / 30),
                              child: Text(
                                'EMS DIRECT',
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 5.0,
                                  fontSize: 14,
                                  fontFamily: 'HelveticaNeueLight',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }
}
