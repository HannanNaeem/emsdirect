import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/services/ops_database.dart';

class BagDetails extends StatefulWidget {
  var _dbName;
  String _name;
  BagDetails(String dbName, String name) {
    _dbName = dbName;
    _name = name;
  }

  @override
  _bagDetailsState createState() => _bagDetailsState(_dbName, _name);
}

class _bagDetailsState extends State<BagDetails> {
  var _bagData;
  var updatedYesNo = [];
  var names = [
    'Items',
    'Bp apparatus',
    'Crepe',
    'Deep heat',
    'Depressors',
    'Face masks',
    'Gauze',
    'Gloves',
    'ORS',
    'Open wove',
    'Polyfax',
    'Polyfax plus',
    'Pyodine',
    'Saniplast',
    'Scissors',
    'Stethoscope',
    'Tape',
    'Thermometer',
    'Triangular bandage',
    'Wintogeno'
  ];
  var data = [];
  var _name;
  int index = 0;
  _bagDetailsState(String _Name, String Name) {
    _name = Name;
    var index = 1;
    _bagData = Firestore.instance
        .collection("EquipmentBags")
        .document(_Name)
        .get()
        .then((doc) {
      setState(() {
        for (var i in names) {
          if (doc[i] != null) data.add(doc[i]);
          index = index + 1;
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    print('data: $data');

    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xff142850),
              title: Text(
                _name,
                style: TextStyle(
                  fontFamily: 'HelveticaNeueLight',
                  letterSpacing: 2.0,
                  fontSize: 24,
                ),
              ),
              centerTitle: true,
              leading: new IconButton(
                icon: new Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            backgroundColor: const Color(0xff27496d),
            body: SingleChildScrollView(
                child: Container(
                    child: Row(children: <Widget>[
//                        Padding(
//                          padding: EdgeInsets.fromLTRB(30, 20, 0, 20),
//                          child: Text(
//                            'Items',
//                            style: TextStyle(
//                              fontFamily: 'HelveticaNeueBold',
//                              letterSpacing: 2.0,
//                              fontSize: 14,
//                            ),
//                          )
//                        ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: names.map((value) {
                  if (value == 'Items') {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(43, 20, 0, 20),
                      child: Text(
                        value,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontFamily: 'HelveticaNeueBold',
                          letterSpacing: 2.0,
                          fontSize: 14,
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                        padding: EdgeInsets.fromLTRB(30, 20, 0, 20),
                        child: Text(
                          value,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontFamily: 'HelveticaNeueBold',
                            letterSpacing: 2.0,
                            fontSize: 11,
                          ),
                        ));
                  }
                }).toList(),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(90, 0, 0, 0),
                child: Text(
                  'Quantity',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontFamily: 'HelveticaNeueBold',
                    letterSpacing: 2.0,
                    fontSize: 14,
                  ),
                ),
              ),
              Column(
                children: data.map((value) {
                  print('wut');
                  return Padding(
                    padding: EdgeInsets.fromLTRB(80, 10, 0, 20),
                    child: TextFormField(
                        decoration: InputDecoration(
                          hintText: value.toString(),
                          hintStyle: TextStyle(
                            color: Colors.grey[700],
                            fontFamily: 'HelveticaNeueLight',
                            letterSpacing: 2.0,
                          ),
                          errorStyle: TextStyle(
                            color: Colors.amber,
                            letterSpacing: 1.0,
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                          focusedErrorBorder: InputBorder.none,
                        ),
                        validator: (String value) {
                          if (int.parse(value) < 0)
                            return 'Quantity must be greater than zero!';

                          if (double.parse(value) - int.parse(value) != 0)
                            return 'Quantity must be an integer!';
                        },
                        onSaved: (String value) {
                          updatedYesNo[index] = 1;
                          data[index] = int.parse(value);
                        }),
                  );
                }).toList(),
              ),
            ])))));
  }
}
