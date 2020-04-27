import 'package:flutter/material.dart';

class DummyPage extends StatefulWidget {
  var location;
  var number;

  DummyPage(var location, var num) {
    location = location;
    number = num;
  }
  @override
  _DummyPageState createState() => _DummyPageState();
}

class _DummyPageState extends State<DummyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.number}'),
      ),
      body: Text('${widget.location}'),
    );
  }
}
