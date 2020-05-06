import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/shared/loading.dart';

// Displays the screen which shows the equipment in the bag against the quantity
// of each equipment which can be edited by the OPS user.

class BagDetails extends StatefulWidget {
  var dbName;
  String name;

  BagDetails(String databaseName, String displayName) {
    dbName = databaseName;
    name = displayName;
  }

  @override
  BagDetailsState createState() => BagDetailsState(dbName, name);
}

class BagDetailsState extends State<BagDetails> {
  //This list contains the name of the equipments which will be displayed on the screen.
  var names = [
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

  //This list contains the name of the equipments in the database which will be used to retrieve data from the document.
  var dbNames = [
    'bpApparatus',
    'crepe',
    'deepHeat',
    'depressors',
    'faceMasks',
    'gauze',
    'gloves',
    'openWove',
    'ors',
    'polyfax',
    'polyfaxPlus',
    'pyodine',
    'saniplast',
    'scissors',
    'stethoscope',
    'tape',
    'thermometer',
    'triangularBandage',
    'wintogeno'
  ];

  // This is used to determine if the page has loaded or not - to display Circular Progress Indicator while the map is being loaded
  bool loading = true;

  // This list will include the quantities of the equipments which will correspond to the equipment name in the above lists.
  var data = [];

  // This list will be used to iterate through the above lists when creating widgets.
  var list = new List<int>.generate(19, (i) => i + 1);

  // Each controller in this list corresponds to each quantity textformfield on the screen.
  // This is used to retrieve data entered by the user in those text fields.
  var controller = new List<TextEditingController>.generate(
      19, (i) => new TextEditingController());

  // The name of the equipment bag in the database
  var databaseName;

  // The name of the equipment bag which will be displayed on the screen
  var displayName;

  // Getting data from the database and storing it in 'data'
  void getQuantities(dbName) async {
    var getData = await Firestore.instance
        .collection('EquipmentBags')
        .document(dbName)
        .get()
        .then((doc) {
      setState(() {
        for (var i in dbNames) {
          data.add(doc[i]);
        }
      });
    });

    // updating loading status
    if (data.length == 19) {
      setState(() {
        loading = false;
      });
    }
  }

  // Constructor
  BagDetailsState(String dbName, String name) {
    // Calling get quantities
    getQuantities(dbName);

    // updating variables
    displayName = name;
    databaseName = dbName;
  }

  // This function is used to update data in the database.
  // index -> the index number at which the equipment name is present in 'dbName'
  // value -> new value which is to be set for the equipment.
  updateData(index, value) async {
    try {
      await Firestore.instance
          .collection('EquipmentBags')
          .document(databaseName)
          .updateData({dbNames[index]: int.parse(value)});
    } catch (e) {
      throw (e);
    }
  }

  // This function is used to figure out if the string s is numeric or not.
  // This is used for input checking of text fields.
 bool isNumeric(String s){
    try{
      var check = double.parse(s);
      return true;
    }catch(e){
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Used to make screen responsive.
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return MaterialApp(
        // checking the value of loading
        home: loading
            ? Loading()
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xff142850),
                  title: Text(
                    displayName,
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
                    child: Column(children: [
                  FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: DataTable(
                        columns: [
                          DataColumn(
                              label: Text(
                            'Items',
                            style: TextStyle(
                              fontFamily: 'HelveticaNeueLight',
                              letterSpacing: 1.0,
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          )),
                          DataColumn(
                              label: SizedBox(
                            width: 1,
                          )),
                          DataColumn(
                              label: Text(
                            ' Quantity',
                            style: TextStyle(
                              fontFamily: 'HelveticaNeueLight',
                              letterSpacing: 1.0,
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          )),
                        ],
                        rows: list.map((value) {
                          return DataRow(cells: [
                            DataCell(Text(
                              names[value - 1],
                              style: TextStyle(
                                fontFamily: 'HelveticaNeueLight',
                                letterSpacing: 1.0,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            )),
                            DataCell(Text('')),
                            DataCell(
                              Center(
                                child: SizedBox(
                                    width: 80.0,
                                    height: 45.0,
                                    child: TextFormField(
                                      controller: controller[value - 1],
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(5.0),
                                        border: new OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(30.0),
                                          ),
                                        ),
                                        hintText: data[value - 1].toString(),
                                        hintStyle: TextStyle(
                                          color: Colors.grey[700],
                                          fontFamily: 'HelveticaNeueLight',
                                          letterSpacing: 1.0,
                                        ),
                                        errorStyle: TextStyle(
                                          color: Colors.amber,
                                          letterSpacing: 1.0,
                                        ),
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        focusedErrorBorder: InputBorder.none,
                                      ),
                                      textAlign: TextAlign.center,
                                    )),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(width * 0.16, height * 0.05,
                          width * 0.16, height * 0.1),
                      child: SizedBox(
                          width: (width + height) * 0.10,
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
                                                fontFamily:
                                                    'HelveticaNeueLight',
                                                letterSpacing: 3.0,
                                                fontSize: 20,
                                                color: const Color(0xff1a832a),
                                              ),
                                            ),
                                            onPressed: () async {
                                              for (var i in list) {
                                                var data =
                                                    controller[i - 1].text;
                                                // Checking if the user entered anything
                                                if (data != '') {
                                                  // Checking if the user input is a number or not
                                                if (!isNumeric(data)) {
                                                  // if the user input isn't a number then a dialog box with an error message is displayed.
                                                  return showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                      context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                            "Quantity must be a number!",
                                                            style: TextStyle(
                                                              fontFamily:
                                                              'HelveticaNeueLight',
                                                              letterSpacing:
                                                              2.0,
                                                              fontSize: 20,
                                                              color: Colors
                                                                  .grey[600],
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                              child: Text(
                                                                'OK',
                                                                style:
                                                                TextStyle(
                                                                  fontFamily:
                                                                  'HelveticaNeueLight',
                                                                  letterSpacing:
                                                                  2.5,
                                                                  fontSize:
                                                                  20,
                                                                  color: const Color(
                                                                      0xff1a832a),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                    context)
                                                                    .pop();
                                                                Navigator.of(
                                                                    context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                }
                                                // Checking if the user input is a negative number
                                                  else if (double.parse(data) < 0) {
                                                    // if the user input is a negative then a dialog box with an error message is displayed.
                                                    return showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                              "Quantity cannot be less than zero!",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'HelveticaNeueLight',
                                                                letterSpacing:
                                                                    2.0,
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .grey[600],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                child: Text(
                                                                  'OK',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'HelveticaNeueLight',
                                                                    letterSpacing:
                                                                        2.5,
                                                                    fontSize:
                                                                        20,
                                                                    color: const Color(
                                                                        0xff1a832a),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  }
                                                  // Checking if the user input is a decimal number
                                                  else if (RegExp(
                                                          r"^(\d*\.)\d+$")
                                                      .hasMatch(data)) {
                                                    // if the user input is a decimal number then a dialog box with an error message is displayed.
                                                    return showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                              "Quantity cannot be in decimals!",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'HelveticaNeueLight',
                                                                letterSpacing:
                                                                    2.0,
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .grey[600],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                child: Text(
                                                                  'OK',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'HelveticaNeueLight',
                                                                    letterSpacing:
                                                                        2.5,
                                                                    fontSize:
                                                                        20,
                                                                    color: const Color(
                                                                        0xff1a832a),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  }

                                                }
                                              }
                                              // If the input is validate, iterating through the text entered and updating the database by calling _updateData
                                              for (var i in list) {
                                                var data =
                                                    controller[i - 1].text;
                                                if (data != '') {
                                                  updateData(i - 1, data);
                                                }
                                              }

                                              // Displaying dialog box to show that the bag has been updated
                                              return showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        "Bag has been updated!",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'HelveticaNeueLight',
                                                          letterSpacing: 2.0,
                                                          fontSize: 20,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          child: Text(
                                                            'OK',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'HelveticaNeueLight',
                                                              letterSpacing:
                                                                  2.5,
                                                              fontSize: 20,
                                                              color: const Color(
                                                                  0xff1a832a),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                          ),
                                          FlatButton(
                                            child: Text(
                                              'NO',
                                              style: TextStyle(
                                                fontFamily:
                                                    'HelveticaNeueLight',
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
                              color: const Color(0xFF73CDE8),
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  letterSpacing: 2.0,
                                  fontFamily: 'HelveticaNeueBold',
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              )))),
                ]))));
  }
}
