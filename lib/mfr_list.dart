import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/mfr_list_card.dart';
import 'package:ems_direct/services/ops_database.dart';
import 'package:ems_direct/models/emergency_models.dart';
import 'package:progress_dialog/progress_dialog.dart';

//THIS FILE HAS TWO STATEFUL WIDGET CLASSES
//The first widget is responsible for displaying the MFR list to the user
//The second widget is called by the first widget,
// to take in user input dynamically when entering a new MFR

GlobalKey<_MfrListState> mfrListGlobalKey = GlobalKey();

class MfrList extends StatefulWidget {
  Key key;

  MfrList(Key passedkey) {
    key = passedkey;
  }

  @override
  _MfrListState createState() => _MfrListState();
}

class _MfrListState extends State<MfrList> {
  var mfrList;

  //add the new MFR item to the list of cards (simple check to avoid duplicates)
  void addToMfrList(var newRecord) {
    setState(() {
      if (!(mfrList.map((item) => (item.rollNo))).contains(newRecord.rollNo))
        mfrList.add(newRecord);
    });
  }

  //a function to get the initial data once the page loads
  void getMfrList() async {
    try {
      var mfrSnapshot =
          await Firestore.instance.collection("Mfr").getDocuments();
      var list = OpsDatabaseService().mfrListFromSnapshot(mfrSnapshot);
      setState(() {
        mfrList = list;
      });
    } catch (e) {
      print(e);
    }
  }

  //this returns the dynamic widget
  Widget _buildDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DynamicDialog();
        });
  }

  @override
  void initState() {
    super.initState();
    getMfrList();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff27496d),
      appBar: AppBar(
        backgroundColor: const Color(0xff142850),
        title: Text(
          'MFRs',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'HelveticaNeueLight',
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: mfrList == null
          //shows a loading widget if no data has been recieved completely
          ? Loading()
          //body with the card and the add MFR button
          : Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(children: <Widget>[
                    //add MFR button
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 20),
                        width: 300,
                        height: 80,
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            _buildDialog();
                          },
                          label: Text(
                            'Add a new MFR',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'HelveticaNeueMedium',
                              color: Colors.black,
                              letterSpacing: 2,
                            ),
                          ),
                          icon: Icon(
                            Icons.add,
                            color: const Color(0xff27496d),
                            size: 30,
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: 10),
                  //the list view
                  Flexible(
                    child: ListView.builder(
                      itemCount: mfrList == null ? 0 : mfrList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: MfrListCard(mfrList[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

//this is the dynamic dialog widget
class DynamicDialog extends StatefulWidget {
  @override
  _DynamicDialogState createState() => _DynamicDialogState();
}

class _DynamicDialogState extends State<DynamicDialog> {
  //variables to store the three required inputs
  var _newMfrGender = "Other";
  var _newRollNo;
  var _mfrIsHostelite = "Hostelite";

  //information for the toggle button's functionality
  List<String> _mfrGenderValues = ["M", "F", "O"];
  List<bool> _isSelectedMfrGender = [false, false, true];
  List<String> _mfrTypeValues = ["Hostelite", "Day Scholar"];
  List<bool> _isSelectedHostelite = [true, false];

  //global key to verify information
  final GlobalKey<FormState> _rollNoKey = GlobalKey<FormState>();

  //! Roll number inout
  Widget _buildRollno() {
    return Form(
      key: _rollNoKey,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: TextFormField(
            decoration: InputDecoration(
              hintText: "MFR Roll No.",
              hintStyle: TextStyle(
                color: Colors.grey[700],
                fontFamily: 'HelveticaNeueLight',
                letterSpacing: 2.0,
              ),
              errorStyle: TextStyle(
                color: Colors.redAccent,
                letterSpacing: 1.0,
              ),
              fillColor: Colors.grey[100],
              filled: false,
              focusedErrorBorder: OutlineInputBorder(),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(),
            ),
            validator: (String value) {
              if (value.isEmpty) return 'Roll number is required!';
              if (!RegExp(r"^[0-9]{8}$").hasMatch(value))
                return 'Please enter the 8 digit LUMS Roll number';
            },
            onSaved: (String value) {
              _newRollNo = value;
            }),
      ),
    );
  }

  //! Gender input
  Widget _buildGenderSelector() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            "Select MFR gender:",
            style: TextStyle(
              fontFamily: "HelveticaNeueLight",
              fontSize: 20,
              color: const Color(0xff142850),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ToggleButtons(
            borderColor: Colors.grey[400],
            disabledBorderColor: Colors.grey[400],
            fillColor: const Color(0xff27496d),
            selectedColor: Colors.white,
            borderRadius: BorderRadius.circular(10),
            constraints: BoxConstraints(
              minHeight: 30,
              minWidth: 50,
            ),
            children: <Widget>[
              Text(
                "Male",
              ),
              Text(
                "Female",
              ),
              Text("Other"),
            ],
            isSelected: _isSelectedMfrGender,
            onPressed: (int index) {
              setState(() {
                print('here');
                for (int buttonIndex = 0;
                    buttonIndex < _isSelectedMfrGender.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    _newMfrGender = _mfrGenderValues[index];
                    _isSelectedMfrGender[buttonIndex] = true;
                  } else {
                    _isSelectedMfrGender[buttonIndex] = false;
                  }
                }
              });
            },
          ),
        ],
      ),
    );
  }

  //! Hostelite/Dayscholar input
  Widget _buildHosteliteSelector() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            "MFR Type:",
            style: TextStyle(
              fontFamily: "HelveticaNeueLight",
              fontSize: 20,
              color: const Color(0xff142850),
            ),
          ),
          SizedBox(
            height: 7,
          ),
          ToggleButtons(
            borderColor: Colors.grey[400],
            disabledBorderColor: Colors.grey[400],
            fillColor: const Color(0xff27496d),
            selectedColor: Colors.white,
            borderRadius: BorderRadius.circular(10),
            constraints: BoxConstraints(
              minHeight: 30,
              minWidth: 90,
            ),
            children: <Widget>[
              Text(
                "Hostelite",
              ),
              Text(
                "Day Scholar",
              ),
            ],
            onPressed: (int index) {
              setState(() {
                for (int buttonIndex = 0;
                    buttonIndex < _isSelectedHostelite.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    _mfrIsHostelite = _mfrTypeValues[index];
                    _isSelectedHostelite[buttonIndex] = true;
                  } else {
                    _isSelectedHostelite[buttonIndex] = false;
                  }
                }
              });
            },
            isSelected: _isSelectedHostelite,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //getting the screen sizes
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    final height = screenSize.height;

    //initializing the progress dialog here to respond to user's correct input
    ProgressDialog pr =
        new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: 'Adding record...',
        borderRadius: 8.0,
        backgroundColor: Colors.white,
        progressWidget: Padding(
          padding: EdgeInsets.fromLTRB(15, 12, 12, 12),
          child: CircularProgressIndicator(
            strokeWidth: 5,
            //backgroundColor: Colors.red,
            valueColor:
                new AlwaysStoppedAnimation<Color>(const Color(0xff27496d)),
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontFamily: 'HelveticaNeueLight'));

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      content: Container(
        height: 450,
        width: width * 0.8,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  'Enter MFR information below',
                  style: TextStyle(
                    fontFamily: "HelveticaNeueLight",
                    //fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: const Color(0xff142850),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'MFR roll number:',
                  style: TextStyle(
                    fontFamily: "HelveticaNeueLight",
                    fontSize: 20,
                    color: const Color(0xff142850),
                  ),
                ),
                SizedBox(height: 10),
                _buildRollno(),
                SizedBox(height: 10),
                _buildGenderSelector(),
                SizedBox(height: 10),
                _buildHosteliteSelector(),
                SizedBox(height: 10),
                //the row contains the two buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeueLight',
                          letterSpacing: 2.0,
                          fontSize: 22,
                          color: const Color(0xff1a832a),
                        ),
                      ),
                      onPressed: () async {
                        //check output
                        if (!(_rollNoKey.currentState.validate())) {
                          return;
                        }
                        _rollNoKey.currentState.save();
                        //store all values
                        print(_newRollNo);
                        print(_newMfrGender);
                        print(_mfrIsHostelite);
                        //see if document exists
                        try {
                          QuerySnapshot docSnaphot = await Firestore.instance
                              .collection('UserData')
                              .where('rollNo', isEqualTo: _newRollNo)
                              .getDocuments();
                          if (docSnaphot.documents.length == 0) {
                            print('wrong');
                            //failed - show error popup
                            return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      "The user must be registered as a student",
                                      style: TextStyle(
                                        fontFamily: 'HelveticaNeueLight',
                                        letterSpacing: 2.0,
                                        fontSize: 20,
                                        color: const Color(0xffee0000),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          'OK',
                                          style: TextStyle(
                                            fontFamily: 'HelveticaNeueLight',
                                            letterSpacing: 2.5,
                                            fontSize: 20,
                                            color: const Color(0xff1a832a),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          } else {
                            pr.show();
                            //else get relevant stuff from userDoc and make new MFR document
                            var docData = docSnaphot.documents[0].data;
                            var newData = {
                              'contact': docData['contact'],
                              'gender': _newMfrGender,
                              'isActive': false,
                              'isHostelite':
                                  _mfrIsHostelite == 'Hostelite' ? true : false,
                              'isOccupied': false,
                              'isSenior': false,
                              'location': GeoPoint(31, 76),
                              'name': docData['name']
                            };
                            var mfrModelItem = MfrListModel(
                              name: newData['name'],
                              rollNo: _newRollNo,
                              gender: newData['gender'],
                              contact: newData['contact'],
                              isHostelite: newData['isHostelite'],
                              isSenior: newData['isSenior'],
                            );
                            //make the mfr doc
                            await Firestore.instance
                                .collection('Mfr')
                                .document(_newRollNo)
                                .setData(newData);
                            //update user data
                            await Firestore.instance
                                .collection('UserData')
                                .document(docSnaphot.documents[0].documentID)
                                .updateData({'emsType': 'mfr'});
                            //add a new card to the list
                            mfrListGlobalKey.currentState
                                .addToMfrList(mfrModelItem);

                            pr.hide();
                            Navigator.of(context).pop();
                          }
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                    ),
                    FlatButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeueLight',
                          letterSpacing: 2,
                          fontSize: 22,
                          color: const Color(0xffee0000),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
