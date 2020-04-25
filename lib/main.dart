import 'package:ems_direct/pages/SelectLogin.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/pages/live_status.dart';
import 'package:ems_direct/pages/emergency_numbers.dart';
import 'package:ems_direct/ops.dart';
import 'package:ems_direct/pages/login_student.dart';
import 'package:ems_direct/pages/login_ems.dart';
import 'package:ems_direct/pages/SplashScreen.dart';
import 'package:ems_direct/pages/available_MFRs.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      routes: {
        '/login_student': (context) => LoginStudent(),
        '/login_ems_mfr': (context) => LoginEms('mfr'),
        '/login_ems_ops': (context) => LoginEms('ops'),
        '/live_status': (context) => LiveStatus(),
        '/emergencyNumbers': (context) => EmergencyNumbers(),
        '/select_login': (context) => SelectLogin(),
        '/availableMFRs': (context) => AvailableMfrs(),
      },
    );
  }
}
