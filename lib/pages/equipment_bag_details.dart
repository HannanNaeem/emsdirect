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
    'Wintogeno',

  ];
  var data = [];
  var _name;
  int index = 0;
  _bagDetailsState(String _Name, String Name) {
    _name = Name;
    _bagData = Firestore.instance
        .collection("EquipmentBags")
        .document(_Name)
        .get()
        .then((doc) {
      setState(() {
        data.add(-1);
        for (var i in names) {
          if (doc[i] != null) data.add(doc[i]);
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
                    child: Column(children: <Widget>[
                      Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: names.map((value) {
                              if (value == 'Items') {
                                return
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(43, 20, 0, 20),
                                    child: Text(
                                      value,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontFamily: 'HelveticaNeueBold',
                                        letterSpacing: 2.0,
                                        fontSize: 16,
                                      ),
                                    ),

                                  );
                              }
                              else {
                                return Padding(
                                    padding: EdgeInsets.fromLTRB(30, 20, 0, 20),
                                    child: SizedBox(height: 30,
                                        child: Text(
                                          value,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontFamily: 'HelveticaNeueBold',
                                            letterSpacing: 2.0,
                                            fontSize: 13,
                                          ),
                                        )));
                              }
                            }).toList(),
                          ),
                          Column(
                            children: data.map((value) {
                              if(value != -1){
                                return Padding(
                                    padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                                    child: SizedBox(width: 80,
                                      height: 70,
                                      child: TextFormField(
                                          decoration: InputDecoration(
                                            border: new OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(
                                                const Radius.circular(10.0),
                                              ),
                                            ),
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

                                    )
                                );
                              }else if(value == -1){
                                return
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(50, 20, 0, 20),
                                    child: Text(
                                      'Quantity',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontFamily: 'HelveticaNeueBold',
                                        letterSpacing: 2.0,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                              }
                            }).toList(),
                          ),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(
                              width * 0.20, height * 0.1, width * 0.16, 10.0),
                          child: SizedBox(
                              width: (width + height) * 0.18,
                              height: (width + height) * 0.04,
                              child: RaisedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              "Are you sure?",
                                              style: TextStyle(
                                                fontFamily: 'HelveticaNeueLight',
                                                letterSpacing: 2.0,
                                                fontSize: 20,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  'YES',
                                                  style: TextStyle(
                                                    fontFamily: 'HelveticaNeueLight',
                                                    letterSpacing: 3.0,
                                                    fontSize: 20,
                                                    color: const Color(0xff1a832a),
                                                  ),
                                                ),
                                                onPressed: () async {

//                                        todo: save to database
                                                },
                                              ),
                                              FlatButton(
                                                child: Text(
                                                  'NO',
                                                  style: TextStyle(
                                                    fontFamily: 'HelveticaNeueLight',
                                                    letterSpacing: 2.5,
                                                    fontSize: 20,
                                                    color: const Color(0xffee0000),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  textColor: Colors.cyan[500],
                                  color: const Color(0xff142850),
                                  // todo: update occupied status
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: (width + height) * 0.012,
                                      letterSpacing: 3.0,
                                      fontFamily: 'HelveticaNeueBold',
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  )))
                      ),



              ]
              ),

              ),

            )

        )
    );
  }
}
