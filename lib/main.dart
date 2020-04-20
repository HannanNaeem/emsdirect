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
                scale:1,
              
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
