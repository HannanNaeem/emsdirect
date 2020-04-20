import 'dart:ui';
import 'SplashScreen.dart';
import 'package:flutter/material.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SplashScreen(),);
  }
}
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.cyan[800],


      body: 
        Center(
          child: 
            Image.asset(
                
                'assets/ems_logo.png',
                scale:1,
              
            ),
          
        ),

    );
  }
}
