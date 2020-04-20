import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ems_direct/records.dart';
import 'package:ems_direct/notifications.dart';
import 'package:ems_direct/ops.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/ops',
      routes: {
        '/records': (context) => Records(),
        '/ops': (context) => Ops(),
        '/notifications': (context) => Notifications(),
        //'/log' : (context) => EmergencyLog()
      },
    ));
