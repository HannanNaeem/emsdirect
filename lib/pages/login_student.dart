import 'package:flutter/material.dart';

class LoginStudent extends StatefulWidget {
  @override
  _LoginStudentState createState() => _LoginStudentState();
}

class _LoginStudentState extends State<LoginStudent> {

  String _email;
  String _password;
  bool _keepSignedin = false;
  String _name;
  String _rollno;
  String _contact;

  List<bool> _isSelected = [true,false];

  final GlobalKey<FormState> _loginformKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signupformKey = GlobalKey<FormState>();

  Widget _buildEmail() {
    return Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: TextFormField(
    
                      decoration: InputDecoration(
                
                        hintText: 'Email Address',
                        hintStyle: TextStyle(
                          color: Colors.grey[700],
                          fontFamily: 'HelveticaNeue',
                          letterSpacing: 2.0,
                          ),
                        errorStyle: TextStyle(
                          color: Colors.amber,
                          fontFamily: 'Helveticaneue',
                          letterSpacing: 1.0,
                          ),            
                        fillColor: Colors.grey[200],
                        filled: true,
                        focusedErrorBorder: InputBorder.none,
                        
                      ),


                      validator: (String value) {
                        if(value.isEmpty)
                          return 'Email is required!';

                        if(!RegExp(r"^[a-zA-Z0-9_.+-]+@(?:(?:[a-zA-Z0-9-]+\.)?[a-zA-Z]+\.)?(lums.edu)\.pk$").hasMatch(value))
                        {
                          return 'Please enter a LUMS email address';
                        }
                      },

                      onSaved: (String value) {
                        _email = value;
                      }
                    ),
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
                          fontFamily: 'HelveticaNeue',
                          letterSpacing: 2.0,
                          ),
                        errorStyle: TextStyle(
                          color: Colors.amber,
                          fontFamily: 'Helveticaneue',
                          letterSpacing: 1.0,
                          ),            
                        fillColor: Colors.grey[200],
                        filled: true,
                        focusedErrorBorder: InputBorder.none,
                        
                      ),


                      validator: (String value) {
                        if(value.isEmpty)
                          return 'Password is required!';
                      },

                      onSaved: (String value) {
                        _password = value;
                      }
                    ),
    );
  }

  Widget _buildKeepSignedIn() {
    return Row( children: <Widget> [
      Checkbox(
        
        value: _keepSignedin,
        tristate: false,
        checkColor: Colors.grey[800],
        activeColor: Colors.grey[300],
        onChanged: (bool newValue) {
          setState(() {
            _keepSignedin = newValue;
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
                          fontFamily: 'HelveticaNeue',
                          letterSpacing: 2.0,
                          ),
                        errorStyle: TextStyle(
                          color: Colors.amber,
                          fontFamily: 'Helveticaneue',
                          letterSpacing: 1.0,
                          ),            
                        fillColor: Colors.grey[200],
                        filled: true,
                        focusedErrorBorder: InputBorder.none,
                        
                      ),


                      validator: (String value) {
                        if(value.isEmpty)
                          return 'Name is required!';

                      },

                      onSaved: (String value) {
                        _name = value;
                      }
                    ),
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
                          fontFamily: 'HelveticaNeue',
                          letterSpacing: 2.0,
                          ),
                        errorStyle: TextStyle(
                          color: Colors.amber,
                          fontFamily: 'Helveticaneue',
                          letterSpacing: 1.0,
                          ),            
                        fillColor: Colors.grey[200],
                        filled: true,
                        focusedErrorBorder: InputBorder.none,
                        
                      ),


                      validator: (String value) {
                        if(value.isEmpty)
                          return 'Roll number is required!';

                        if(!RegExp(r"^[0-9]{8}$").hasMatch(value))
                          return 'Please enter your 8 digit LUMS Roll number';

                      },

                      onSaved: (String value) {
                        _rollno = value;
                      }
                    ),
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
                          fontFamily: 'HelveticaNeue',
                          letterSpacing: 2.0,
                          ),
                        errorStyle: TextStyle(
                          color: Colors.amber,
                          fontFamily: 'Helveticaneue',
                          letterSpacing: 1.0,
                          ),            
                        fillColor: Colors.grey[200],
                        filled: true,
                        focusedErrorBorder: InputBorder.none,
                        
                      ),


                      validator: (String value) {
                        if(value.isEmpty)
                          return 'Contact number is required!';

                        if(!RegExp(r"^[0-9]{11}$").hasMatch(value))
                          return 'Invalid number';

                      },

                      onSaved: (String value) {
                        _contact = value;
                      }
                    ),
    );
  }


  Widget _buildForm(){
    
    if(_isSelected[0]== true)
    {
    return  Container(
          height:355,
          child: Form(
                key: _loginformKey,
                child: Column(
                  
                  //main axis allignment here
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[
                    
                    SizedBox(height:40),
                    _buildEmail(),
                    SizedBox(height:30),
                    _buildPassword(),
                    SizedBox(height:10),
                    _buildKeepSignedIn(),

                    SizedBox(height: 30),

                    ButtonTheme(
                      height: 55.0,
                      minWidth: 120.0,
                      child: RaisedButton(

                        

                        onPressed: () {
                          if(!_loginformKey.currentState.validate()){
                            return;
                          }

                          _loginformKey.currentState.save();
                          
                          //! TESTING
                          print(_email);
                          print(_password);
                          print(_keepSignedin);
                        },
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                                color: Colors.white, 
                                fontFamily: 'HelveticaNeue',
                                letterSpacing: 3.0,
                                )
                        ),
                        color: Colors.cyan,
                        shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                ),
                      
                      ),
                    ),

                  ],),
              ),
    );
    }
    else if(_isSelected[1] == true)
      return Form(
              key: _signupformKey,
              child: Column(
                
                //main axis allignment here
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                  
                  SizedBox(height:40),
                  _buildName(),
                  SizedBox(height:30),
                  _buildRollno(),
                  SizedBox(height:30),
                  _buildContact(),
                   SizedBox(height:30),
                  _buildEmail(),
                  SizedBox(height:30),
                  _buildPassword(),
                  SizedBox(height:30),

                  

                  ButtonTheme(
                    height: 55.0,
                    minWidth: 120.0,
                    child: RaisedButton(

                      

                      onPressed: () {
                        if(!_signupformKey.currentState.validate()){
                          return;
                        }

                        _signupformKey.currentState.save();
                        
                        //! TESTING
                        print(_name);
                        print(_rollno);
                        print(_contact);
                        print(_email);
                        print(_password);
                        
                      },
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                              color: Colors.white, 
                              fontFamily: 'HelveticaNeue',
                              letterSpacing: 3.0,
                              )
                      ),
                      color: Colors.cyan,
                      shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              ),
                    
                    ),
                  ),

                ],),
            );
  }


  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
 
      backgroundColor: Colors.cyan[800],

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0,
        elevation: 0.0,
      ),

      body: SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Column(
                      
                      children: <Widget>[
                        
                        Image.asset(
                          'assets/ems_logo.png',
                          scale: 3.2,
                          ),

                        SizedBox(height: 40),

                        Center(
                          child: ToggleButtons(
                            borderColor: Colors.cyan[800],
                            selectedColor: Colors.grey[400],
                            splashColor: Colors.grey[500],
                            fillColor: Colors.transparent,
                            
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(56, 5, 56, 5),
                                  child: Text('LOGIN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 2.0,
                                    fontFamily: 'HelveticaNeueBold',
                                    fontWeight: FontWeight.bold,
                                    ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(45, 5, 45, 5),
                                  child: Text('SIGN UP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 2.0,
                                    fontFamily: 'HelveticaNeueBold',
                                    fontWeight: FontWeight.bold,
                                    ),
                                ),
                              ),
                            ],

                            selectedBorderColor: Colors.white,

                            isSelected: _isSelected,

                            onPressed: (int index) {
                              setState(() {
                                _isSelected[(index+1)%2] = false;
                                _isSelected[index] = true;
                                
                              });
                            }

                          ),
                        ),


                        
                          _buildForm(),

                        SizedBox(height: 40,),
                        

                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,30),
                          child: Text(
                            'EMS Direct',
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 5.0,
                              fontSize: 15,
                              fontFamily: 'HelveticaNeue',
                            ),
                            ),
                        ),

                      


              ],),
                  ),
            ),
        ),
      )
      
    );
  }
}
