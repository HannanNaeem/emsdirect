
import 'package:ems_direct/services/auth.dart';
import 'package:flutter/material.dart';

class LoginEms extends StatefulWidget {

  String _emsType = '';

  LoginEms(String emsType){
    _emsType = emsType;
  }

  @override
  _LoginEmsState createState() => _LoginEmsState(_emsType);
}

class _LoginEmsState extends State<LoginEms> {

  String _emsType = null;

  _LoginEmsState(String emsType){
    _emsType = emsType;
  }

  
  String _email;
  String _password;
  bool _keepSignedin = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authEms = AuthService();

  Widget _buildEmail() {
    return Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: TextFormField(
    
                      decoration: InputDecoration(
                
                        hintText: 'Email Address',
                        hintStyle: TextStyle(
                          color: Colors.grey[700],
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.bold,
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
                          fontWeight: FontWeight.bold,
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

  Widget _buildForm(){
    return  Container(
      height:367,
      child: Form(
                key: _formKey,
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

                        

                        onPressed: () async {
                          if(!_formKey.currentState.validate()){
                            return;
                          }

                          _formKey.currentState.save();

                          // login
                          dynamic result = await _authEms.signIn(_email, _password);
                          
                          //! TESTING
                          print(_email);
                          print(_password);
                          print(_keepSignedin);

                          if(result == null){

                            print("Error signing in!");
                          }
                          else{
                            print("User signed in!");
                            print("User id: ${result.uid}");
                            
                            Navigator.pop(context);
                            if(_emsType == 'ops')
                            {
                              Navigator.pushReplacementNamed(context,'/ops_home');
                            }
                            else if (_emsType == 'mfr')
                            {
                              Navigator.pushReplacementNamed(context,'/mfr_home');
                            }

                          }
                        },
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                                color: Colors.white, 
                                fontFamily: 'HelveticaNeueBold',
                                letterSpacing: 3.0,
                                )
                        ),
                        color: const Color(0xFF73CDE8),
                        shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                ),
                      
                      ),
                    ),

                  ],),
              ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
  
    return Scaffold(
      
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        backgroundColor: const Color(0xff142850) ,
        elevation: 0.0,
      ),

      body: Container(
        constraints:BoxConstraints.expand(),
        decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [const Color(0xff00a8cc),const Color(0xff142850) ],
                  
                  
                  ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Center(
                      child: Column(children: <Widget>[
                          
                          Image.asset(
                            'assets/ems_logo.png',
                            scale: 3.2,
                            ),

                          
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                            child: Text('EMS LOGIN',
                                      style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 8.0,
                                        fontFamily: 'HelveticaNeueLight',
                                        fontSize: 24,
                                        
                                        ),
                                    ),
                          ),
                          


                          _buildForm(),

                          SizedBox(height: 40,),
                              

                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,0,0,30),
                            child: Text(
                              'EMS DIRECT',
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 5.0,
                                fontSize: 15,
                                fontFamily: 'HelveticaNeueLight',
                                
                              ),
                              ),
                          ),


                ],),
              ),
            ),
          ),
        ),
      )
    );
  }
}