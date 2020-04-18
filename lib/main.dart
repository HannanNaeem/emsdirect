import 'dart:ui';
import 'package:ems_direct/pages/login_student.dart';
import 'package:ems_direct/pages/login_ems.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  
  initialRoute: '/login_student',
  routes: {
    '/' : (context) => Home(),
    '/login_student' : (context) => LoginStudent(),
    '/login_ems' : (context) => Loginems(),
  },

));


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.cyan[800],

      // appBar: AppBar(
      //   backgroundColor: Colors.cyan[800],
      //   title: Text('Ems Direct',
      //     style: TextStyle(
          
      //       color:Colors.white,
      //       fontSize: 23.0,
      //       fontFamily: 'HelveticaNeueLight',

      //     )
      //   ),
      //   centerTitle: true,

      // ),

      body: 
        Center(
          child: 
            Image.asset(
                
                'assets/ems_logo.png',
                scale:2.3,
              
            ),
          
        ),

      

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: Colors.cyan[300],
      //   child: Text("Tap"),
      // ),

    );
  }
}
