import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/shared/loading.dart';

// Displays the screen which shows the equipment in the inventory against the quantity
// of each equipment which can be edited by the OPS user.

class Inventory extends StatefulWidget {
  @override
  InventoryState createState() => InventoryState();
}

class InventoryState extends State<Inventory> {
  //This list contains the name of the equipments which will be displayed on the screen.
  var names = [
    'Alcohol pad',
    'Arm sling',
    'Bp apparatus',
    'Crepe',
    'Crutches',
    'Deep heat',
    'Depressors',
    'Face masks',
    'Gauze',
    'Gloves',
    'Hard collar',
    'Open wove',
    'Ors',
    'Polyfax',
    'Polyfax plus',
    'Pyodine',
    'Saniplast',
    'Scissors',
    'Soft collar',
    'Spine board',
    'Stethoscope',
    'Stretcher',
    'Tape',
    'Thermometer',
    'Triangular bandage',
    'Wheelchair',
    'Wintogeno',
  ];

  //This list contains the name of the equipments in the database which will be used to retrieve data from the document.
  var dbName = [
    'alcoholPad',
    'armSling',
    'bpApparatus',
    'crepe',
    'crutches',
    'deepHeat',
    'depressors',
    'faceMasks',
    'gauze',
    'gloves',
    'hardCollar',
    'openWove',
    'ors',
    'polyfax',
    'polyfaxPlus',
    'pyodine',
    'saniplast',
    'scissors',
    'softCollar',
    'spineBoard',
    'stethoscope',
    'stretcher',
    'tape',
    'thermometer',
    'triangularBandage',
    'wheelchair',
    'wintogeno'
  ];

  // This list will include the quantities of the equipments which will correspond to the equipment name in the above lists.
  var data = [];

  // This is used to determine if the page has loaded or not - to display Circular Progress Indicator while the map is being loaded
  bool loading = true;

  // This list will be used to iterate through the above lists when creating widgets.
  var list = new List<int>.generate(27, (i) => i + 1);

  // Each controller in this list corresponds to each quantity textformfield on the screen.
  // This is used to retrieve data entered by the user in those text fields.
  var controller = new List<TextEditingController>.generate(
      27, (i) => new TextEditingController());

  // Getting data from the database and storing it in 'data'
  void getQuantities() async {
    var databaseData = await Firestore.instance
        .collection('Inventory')
        .document('Inventory')
        .get()
        .then((doc) {
      setState(() {
        for (var i in dbName) {
          data.add(doc[i]);
        }
      });
    });

    // updating loading status
    if(data.length == 27){
      setState(() {
        loading = false;
      });
    }
  }
  // Constructor
  InventoryState() {
    // calling getQuantities
    getQuantities();
  }

  // This function is used to update data in the database.
  // index -> the index number at which the equipment name is present in 'dbName'
  // value -> new value which is to be set for the equipment.
  updateData(index, value) async {
    try {
      await Firestore.instance
          .collection("Inventory")
          .document("Inventory")
          .updateData({dbName[index]: int.parse(value)});
    } catch (e) {
      throw (e);
    }
  }

  // This function is used to figure out if the string s is numeric or not.
  // This is used for input checking of text fields.
  // This was taken from the internet.
  bool isNumeric(String s) {

    if (s == null) {
      return false;
    }

    return double.parse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    // Used to make screen responsive.
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return MaterialApp(
        home: loading
            ? Loading()
            :Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xff142850),
              title: Text(
                'Inventory',
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
              Container(
                child: FittedBox(
                  child: DataTable(
                    columns: [
                      DataColumn(
                          label: Text(
                        'Items',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeueBold',
                          letterSpacing: 2.0,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      )),
                      DataColumn(
                          label: SizedBox(
                        width: 7,
                      )),
                      DataColumn(
                          label: Text(
                        ' Quantity',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeueBold',
                          letterSpacing: 2.0,
                          fontSize: 16,
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
                            letterSpacing: 2.0,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        )),
                        DataCell(Text('')),
                        DataCell(
                          SizedBox(
                              width: 100.0,
                              height: 45.0,
                              child: TextFormField(
                                controller: controller[value - 1],
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(5.0),
                                  border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(10.0),
                                    ),
                                  ),
                                  hintText: data[value - 1].toString(),
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
                                textAlign: TextAlign.center,
                              )),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
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
                                          for (var i in list) {
                                            var data = controller[i - 1].text;

                                            // Checking if the user entered anything
                                            if (data != '') {
                                              // Checking if the user input is a number or not
                                              if (!isNumeric(data)) {
                                                // if the user input isn't a number then a dialog box with an error message is displayed.
                                                return showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          "Quantity must be a number!",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'HelveticaNeueLight',
                                                            letterSpacing: 2.0,
                                                            fontSize: 20,
                                                            color: Colors
                                                                .grey[600],
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
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          "Quantity cannot be less than zero!",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'HelveticaNeueLight',
                                                            letterSpacing: 2.0,
                                                            fontSize: 20,
                                                            color: Colors
                                                                .grey[600],
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
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              }
                                              // Checking if the user input is a decimal number
                                              else if (RegExp(r"^(\d*\.)\d+$")
                                                  .hasMatch(data)) {
                                                // if the user input is a decimal number then a dialog box with an error message is displayed.
                                                return showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          "Quantity cannot be in decimals!",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'HelveticaNeueLight',
                                                            letterSpacing: 2.0,
                                                            fontSize: 20,
                                                            color: Colors
                                                                .grey[600],
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
                                            var data = controller[i - 1].text;
                                            if (data != '') {
                                              updateData(i - 1, data);
                                            }
                                          }

                                          // Displaying dialog box to show that inventory has been updated
                                          return showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    "Inventory has been updated!",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'HelveticaNeueLight',
                                                      letterSpacing: 2.0,
                                                      fontSize: 20,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text(
                                                        'OK',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'HelveticaNeueLight',
                                                          letterSpacing: 2.5,
                                                          fontSize: 20,
                                                          color: const Color(
                                                              0xff1a832a),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
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
                          color: const Color(0xFF73CDE8),
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
                          )))),
            ]))));
  }
}
