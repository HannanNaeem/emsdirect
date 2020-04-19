import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ems_direct/pages/MFR_home.dart';
import 'package:ems_direct/pages/emergency_numbers.dart';
import 'package:ems_direct/pages/available_MFRs.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/mfrHome',
      routes: {
        '/mfrHome': (context) => MFRHome(),
        '/emergencyNumbers': (context) => EmergencyNumbers(),
        '/availableMfrs': (context) => AvailableMfrs(),
        //'/mfrMap': (context) =>,
        //'/mfrReportEmergency'(context) =>,
      },
    ));
