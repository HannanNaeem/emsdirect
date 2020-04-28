import 'package:ems_direct/pages/student_home.dart';
import 'package:ems_direct/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/services/auth.dart';

class LoginStudent extends StatefulWidget {
  @override
  _LoginStudentState createState() => _LoginStudentState();
}

class _LoginStudentState extends State<LoginStudent>
    with SingleTickerProviderStateMixin {
  bool _loading = false;

  String _email;
  String _password;
  bool _keepSignedIn = false;
  String _name;
  String _rollno;
  String _contact;

  final GlobalKey<FormState> _loginformKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signupformKey = GlobalKey<FormState>();
  final AuthService _authStudent = AuthService();

  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

  Widget _buildName() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextFormField(
          decoration: InputDecoration(
            hintText: 'Full Name',
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
            if (value.isEmpty) return 'Name is required!';
          },
          onSaved: (String value) {
            _name = value;
          }),
    );
  }

  Widget _buildRollno() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextFormField(
          decoration: InputDecoration(
            hintText: 'Roll No.',
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
            if (value.isEmpty) return 'Roll number is required!';

            if (!RegExp(r"^[0-9]{8}$").hasMatch(value))
              return 'Please enter your 8 digit LUMS Roll number';
          },
          onSaved: (String value) {
            _rollno = value;
          }),
    );
  }

  Widget _buildContact() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextFormField(
          decoration: InputDecoration(
            hintText: 'Contact Number',
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
            if (value.isEmpty) return 'Contact number is required!';

            if (!RegExp(r"^[0-9]{11}$").hasMatch(value))
              return 'Invalid number';
          },
          onSaved: (String value) {
            _contact = value;
          }),
    );
  }

  Widget _buildForm(int index) {
    var screenSize = MediaQuery.of(context).size;
    final height = screenSize.height;
    if (index == 0) {
      return Container(
        height: height/2,
        child: Form(
          key: _loginformKey,
          child: Column(
            //main axis allignment here
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              SizedBox(height: 20),
              _buildEmail(),
              SizedBox(height: 30),
              _buildPassword(),
              SizedBox(height: 10),
              _buildKeepSignedIn(),
              SizedBox(height: 20),
              ButtonTheme(
                height: height / 14,
                minWidth: height / 5,
                child: RaisedButton(
                  onPressed: () async {
                    if (!_loginformKey.currentState.validate()) {
                      return;
                    }

                    _loginformKey.currentState.save();

                    setState(() {
                      _loading = true;
                    });

                    //! TESTING
                    print(_email);
                    print(_password);
                    print(_keepSignedIn);

                    dynamic result =
                        await _authStudent.signIn(_email, _password, '');

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

                      print("Error signing in");
                    } else {
                      print("User signed in!");

                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StudentHome(_keepSignedIn, result)));
                    }
                  },
                  child: Text('LOGIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'HelveticaNeueBold',
                        letterSpacing: 3.0,
                        fontSize: 16,
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
    } else if (index == 1)
      return Form(
        key: _signupformKey,
        child: Column(
          //main axis allignment here
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            SizedBox(height: 20),
            _buildName(),
            SizedBox(height: 20),
            _buildRollno(),
            SizedBox(height: 20),
            _buildContact(),
            SizedBox(height: 20),
            _buildEmail(),
            SizedBox(height: 20),
            _buildPassword(),
            SizedBox(height: 30),
            ButtonTheme(
              height: height/14,
              minWidth: height/5,
              child: RaisedButton(
                onPressed: () async {
                  if (!_signupformKey.currentState.validate()) {
                    return;
                  }

                  _signupformKey.currentState.save();

                  //signup
                  setState(() {
                    _loading = true;
                  });

                  dynamic result = await _authStudent.signUp(
                      _email, _password, _name, _rollno, _contact);

                  //! TESTING
                  print(_name);
                  print(_rollno);
                  print(_contact);
                  print(_email);
                  print(_password);

                  setState(() {
                    _loading = false;
                  });

                  if (result == null) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Signup failed! User already exists",
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

                    print("Error signing up!");
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "A verification email has been sent!",
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
                                  'OK',
                                  style: TextStyle(
                                    fontFamily: 'HelveticaNeueLight',
                                    letterSpacing: 2.5,
                                    fontSize: 20,
                                    color: const Color(0xff1a832a),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _controller.animateTo(0);
                                },
                              ),
                            ],
                          );
                        });
                    print("User created!");
                  }
                },
                child: Text('SIGN UP',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'HelveticaNeueBold',
                      fontSize: 16,
                      letterSpacing: 3.0,
                    )),
                color: const Color(0xFF73CDE8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            SizedBox(height: height/20),
          ],
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
              bottomOpacity: 0,
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
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(height/ 30, 0, height/30, 0),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'assets/ems_logo.png',
                            scale: (height/100)/2,
                          ),
                          SizedBox(height: 40),
                          TabBar(
                            controller: _controller,
                            indicatorColor: Colors.white,
                            tabs: <Widget>[
                              Tab(
                                  child: Text('LOGIN',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'HelveticaNeueLight',
                                        fontSize: 18.0,
                                        letterSpacing: 4.0,
                                      ))),
                              Tab(
                                  child: Text('SIGNUP',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'HelveticaNeueLight',
                                        fontSize: 18.0,
                                        letterSpacing: 4.0,
                                      ))),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: height / 3,
                            width: screenSize.width,
                            child: TabBarView(
                              controller: _controller,
                              children: <Widget>[
                                SingleChildScrollView(
                                  child: _buildForm(0)
                                ),
                                SingleChildScrollView(
                                  child: _buildForm(1),
                                ),
                              ],
                            ),
                          ),

                          //_buildForm(),
                          SizedBox(height: 20,),
                          Align(
                            alignment: Alignment.bottomCenter,
                              child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, height/30),
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
            )
          );
  }
}
