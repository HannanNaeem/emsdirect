
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/models/emergency_models.dart';
import 'package:ems_direct/ops.dart';
import 'package:ems_direct/pages/MFR_home.dart';
import 'package:ems_direct/services/auth.dart';
import 'package:ems_direct/services/ops_database.dart';
import 'package:ems_direct/services/ops_notification_wrapper.dart';
import 'package:ems_direct/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginEms extends StatefulWidget {
  String _emsType = '';

  LoginEms(String emsType) {
    _emsType = emsType;
  }

  @override
  _LoginEmsState createState() => _LoginEmsState(_emsType);
}

class _LoginEmsState extends State<LoginEms> {
  String _emsType = null;

  _LoginEmsState(String emsType) {
    _emsType = emsType;
  }

  bool _loading = false;
  String _email;
  String _password;
  bool _keepSignedIn = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authEms = AuthService();

  Widget _buildEmail() {
    var screenSize = MediaQuery.of(context).size;
    final height = screenSize.height;
    return Padding(
      padding: EdgeInsets.fromLTRB(height / 75, 0, height / 75, 0),
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

  Widget _buildPassword() {
    var screenSize = MediaQuery.of(context).size;
    final height = screenSize.height;
    return Padding(
      padding: EdgeInsets.fromLTRB(height / 75, 0, height / 75, 0),
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

  Widget _buildForm(final height) {
    return Container(
      height: height / 2,
      child: Form(
        key: _formKey,
        child: Column(
          //main axis allignment here
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            SizedBox(height: height / 40),
            _buildEmail(),
            SizedBox(height: height / 30),
            _buildPassword(),
            SizedBox(height: height / 100),
            _buildKeepSignedIn(),
            SizedBox(height: height / 20),
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
                    _loading = true;
                  });

                  // login
                  dynamic result =
                      await _authEms.signIn(_email, _password, _emsType);

                  //! TESTING
                  print(_email);
                  print(_password);
                  print(_keepSignedIn);

                  if (result == null) {
                    setState(() {
                      _loading = false;
                    });

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

                    print("Error signing in!");
                  } else {
                    print("User signed in!");

                    Navigator.pop(context);
                    if (_emsType == 'ops') {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StreamProvider<List<SevereEmergencyModel>>.value(
                                value: OpsDatabaseService().severeStream,
                                child: StreamProvider<List<DeclinedEmergencyModel>>.value(
                                  value: OpsDatabaseService().declinedStream,
                                  child:OpsWrapper(_keepSignedIn, result),
                                  )
                                )
                          )
                      );
                    } else if (_emsType == 'mfr') {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MFRHome(_keepSignedIn, result),
                          ));
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
                      child: Stack(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/ems_logo.png',
                              scale: (height) / 200,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: height/3.5),
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(0, height / 30, 0, 0),
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
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: height/3),
                            child: _buildForm(height)),
                          SizedBox(
                            height: height / 30,
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: height/1.2),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
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
