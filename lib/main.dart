import 'dart:ui';
import 'package:ems_direct/pages/SelectLogin.dart';
import 'package:ems_direct/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/pages/student_home.dart';
import 'package:ems_direct/pages/live_status.dart';
import 'package:ems_direct/pages/emergency_numbers.dart';
import 'package:ems_direct/records.dart';
import 'package:ems_direct/notifications.dart';
import 'package:ems_direct/ops.dart';
import 'package:ems_direct/pages/login_student.dart';
import 'package:ems_direct/pages/login_ems.dart';
import 'package:ems_direct/pages/SplashScreen.dart';
import 'package:ems_direct/pages/MFR_home.dart';
import 'package:ems_direct/pages/emergency_numbers.dart';
import 'package:ems_direct/pages/available_MFRs.dart';
import 'package:provider/provider.dart';
import 'package:ems_direct/models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MFRHome(true),
      routes: {
        '/login_student': (context) => LoginStudent(),
        '/login_ems_mfr': (context) => LoginEms('mfr'),
        '/login_ems_ops': (context) => LoginEms('ops'),
        '/student_home_keepSignedIn': (context) => StudentHome(true),
        '/student_home': (context) => StudentHome(false),
        '/live_status': (context) => LiveStatus(),
        '/emergencyNumbers': (context) => EmergencyNumbers(),
        '/select_login': (context) => SelectLogin(),
        '/mfr_home_keepSignedIn': (context) => MFRHome(true),
        '/mfr_home': (context) => MFRHome(false),
        '/ops_home': (context) => Ops(),
        '/availableMFRs': (context) => AvailableMfrs(),
      },
    );
  }
}
