import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ems_direct/records.dart';
import 'package:ems_direct/notifications.dart';
import 'package:ems_direct/ops.dart';
import 'package:ems_direct/pages/login_student.dart';
import 'package:ems_direct/pages/login_ems.dart';
import 'package:ems_direct/pages/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/pages/MFR_home.dart';
import 'package:ems_direct/pages/emergency_numbers.dart';
import 'package:ems_direct/pages/available_MFRs.dart';


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

