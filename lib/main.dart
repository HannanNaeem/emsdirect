import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ems_direct/pages/student_home.dart';
import 'package:ems_direct/pages/live_status.dart';
import 'package:ems_direct/pages/emergency_numbers.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/student_home',
  routes: {
    '/student_home' : (context) => StudentHome(),
    '/live_status' : (context) => LiveStatus(),
    '/emergencyNumbers' : (context) => EmergencyNumbers(),
  },

));

