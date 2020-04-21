import 'dart:ui';
import 'package:ems_direct/pages/login_student.dart';
import 'package:ems_direct/pages/login_ems.dart';
import 'package:ems_direct/pages/SplashScreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      routes: {
        '/login_student' : (context) => LoginStudent(),
        '/login_ems': (context) => Loginems(),
      },
    
    );
  }
}
