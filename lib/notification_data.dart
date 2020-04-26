import 'package:flutter/material.dart';

class NotificationData {
  static final timeList = ['2:30', '2:30', '2:30', '2:30', '2:30', '2:30'];

  static final data = [
    {
      'text': 'Pool bag needs restocking! Click here to update.',
      'item': '1',
      'category': 'record'
    },
    {
      'text':
          'New critical emergency on the map. Please assign an MFR to emergency. Click to go to the map.',
      'item': '2',
      'category': 'emergency'
    },
    {
      'text': 'CS bag needs restocking! Click to update',
      'item': '3',
      'category': 'record'
    },
    {'text': 'Uhh nice', 'item': '4', 'category': 'emergency'},
    {'text': 'Hello', 'item': '5', 'category': 'record'},
    {'text': 'What', 'item': '6', 'category': 'emergency'}
  ];

  static final hello = [
    {'text': 'Hello 1.', 'item': '1'},
    {'text': 'Hello 2', 'item': '2'},
    {'text': 'Hello 3', 'item': '3'},
    {'text': 'Uhh nice', 'item': '4'},
    {'text': 'Hello', 'item': '5'},
    {'text': 'What', 'item': '6'}
  ];
}
