import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyCounter extends StatefulWidget {
  int initialValue;
  int min;
  int max;
  Function onChanged;
  int localState;

  MyCounter({
    this.initialValue,
    this.min,
    this.max,
    this.onChanged,
  }) {
    this.localState = this.initialValue;
  }
  @override
  _MyCounterState createState() => _MyCounterState();
}

class _MyCounterState extends State<MyCounter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        //!add button
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              if (widget.localState < widget.max) {
                widget.localState++;
                widget.onChanged(widget.localState);
              }
            }),
        SizedBox(
          width: 10,
        ),
        //!add number
        Text(
          widget.localState.toString(),
          style: TextStyle(
            fontFamily: "HelveticaNeueLight",
            fontSize: 17,
            color: const Color(0xff142850),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        //!add button
        IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              if (widget.localState > widget.min) {
                widget.localState--;
                widget.onChanged(widget.localState);
              }
            }),
      ],
    );
  }
}

class EmergencyReportMfr extends StatefulWidget {
  @override
  _EmergencyReportMfrState createState() => _EmergencyReportMfrState();
}

class _EmergencyReportMfrState extends State<EmergencyReportMfr> {
  final GlobalKey<FormState> _emergencyReportKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _equipmentUsedKey = GlobalKey<FormState>();

  String _patientRollNo; //
  String _patientGender = "Other"; //
  DateTime _emergencyDate = DateTime.now(); //
  String _primaryMfrRollNo; //
  String _primaryMfrName; //
  String _additionalMfrs; //
  String _severity = "Low"; //
  String _patientIsHostelite = "Hostelite"; //
  String _emergencyType = "Trauma"; //
  String _emergencyLocation;
  String _transportUsed = "Yes"; //
  String _emergencyDetails; //

  String _bagUsed = "None";

  bool _autoValidate = false;

  List<String> _pateintGenderValues = ["Male", "Female", "Other"];
  List<bool> _isSelectedPatientGender = [false, false, true];

  List<String> _severityValues = ["Low", "Medium", "High", "Critical"];
  List<bool> _isSelectedSeverity = [true, false, false, false];

  List<String> _pateintTypeValues = ["Hostelite", "Day Scholar"];
  List<bool> _isSelectedHostelite = [true, false];

  List<String> _emergencyTypeValues = ["Trauma", "Medical"];
  List<bool> _isSelectedEmergencyType = [true, false];

  List<String> _transportUsedValues = ["Yes", "No"];
  List<bool> _isSelectedTransportUsed = [true, false];

  // One time consumables
  int _crepe = 0;
  int _openWove = 0;
  int _gauze = 0;
  int _saniplast = 0;
  int _depressors = 0;
  int _triangBandage = 0;
  int _gloves = 0;
  int _faceMasks = 0;
  int _ors = 0;

  // resuable consumables
  int _pyodine = 0;
  int _polyfax = 0;
  int _polyfaxPlus = 0;
  int _wintogeno = 0;
  int _deepHeat = 0;

  //! Roll no form field
  Widget _buildRollno(bool isPatient) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: TextFormField(
          decoration: InputDecoration(
            hintText: isPatient ? "Patient Roll No." : "MFR Roll No.",
            hintStyle: TextStyle(
              color: Colors.grey[700],
              fontFamily: 'HelveticaNeueLight',
              letterSpacing: 2.0,
            ),
            errorStyle: TextStyle(
              color: Colors.redAccent,
              letterSpacing: 1.0,
            ),
            fillColor: Colors.grey[1],
            filled: false,
            focusedErrorBorder: OutlineInputBorder(),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(),
          ),
          validator: (String value) {
            if (value.isEmpty) return 'Roll number is required!';

            if (!RegExp(r"^[0-9]{8}$").hasMatch(value))
              return 'Please enter 8 digit LUMS Roll number';
          },
          onSaved: (String value) {
            if (isPatient)
              _patientRollNo = value;
            else
              _primaryMfrRollNo = value;
          }),
    );
  }

  //! Get date Fucntion
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: _emergencyDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
    );

    if (pickedDate != null && pickedDate != _emergencyDate) {
      setState(() {
        _emergencyDate = pickedDate;
        FocusScope.of(context).requestFocus(FocusNode());
      });
    }
  }

  //! Get time Fucntion
  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay pickedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (pickedTime != null) {
      setState(() {
        _emergencyDate = DateTime(_emergencyDate.year, _emergencyDate.month,
            _emergencyDate.day, pickedTime.hour, pickedTime.minute);
        print(_emergencyDate.toString());
        FocusScope.of(context).requestFocus(FocusNode());
      });
    }
  }

  //! Patient gender
  Widget _buildGenderSelector() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            "Patient gender:",
            style: TextStyle(
              fontFamily: "HelveticaNeueLight",
              fontSize: 17,
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
              minWidth: 70,
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
            onPressed: (int index) {
              setState(() {
                for (int buttonIndex = 0;
                    buttonIndex < _isSelectedPatientGender.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    _patientGender = _pateintGenderValues[index];
                    _isSelectedPatientGender[buttonIndex] = true;
                  } else {
                    _isSelectedPatientGender[buttonIndex] = false;
                  }
                }
              });
            },
            isSelected: _isSelectedPatientGender,
          ),
        ],
      ),
    );
  }

  //! Patient type = isHostelite?
  Widget _buildHosteliteSelector() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            "Patient type:",
            style: TextStyle(
              fontFamily: "HelveticaNeueLight",
              fontSize: 17,
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
              minWidth: 110,
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
                    _patientIsHostelite = _pateintTypeValues[index];
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

  //! Trasnport used
  Widget _buildTransportUsedSelector() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            "Was transport used?",
            style: TextStyle(
              fontFamily: "HelveticaNeueLight",
              fontSize: 17,
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
                "Yes",
              ),
              Text(
                "No",
              ),
            ],
            onPressed: (int index) {
              setState(() {
                for (int buttonIndex = 0;
                    buttonIndex < _isSelectedTransportUsed.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    _transportUsed = _transportUsedValues[index];
                    _isSelectedTransportUsed[buttonIndex] = true;
                  } else {
                    _isSelectedTransportUsed[buttonIndex] = false;
                  }
                }
              });
            },
            isSelected: _isSelectedTransportUsed,
          ),
        ],
      ),
    );
  }

  //! Emergency Type = trauma or medical
  Widget _buildEmergencyTypeSelector() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            "Emergency type:",
            style: TextStyle(
              fontFamily: "HelveticaNeueLight",
              fontSize: 17,
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
                "Trauma",
              ),
              Text(
                "Medical",
              ),
            ],
            onPressed: (int index) {
              setState(() {
                for (int buttonIndex = 0;
                    buttonIndex < _isSelectedEmergencyType.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    _emergencyType = _emergencyTypeValues[index];
                    _isSelectedEmergencyType[buttonIndex] = true;
                  } else {
                    _isSelectedEmergencyType[buttonIndex] = false;
                  }
                }
              });
            },
            isSelected: _isSelectedEmergencyType,
          ),
        ],
      ),
    );
  }

  //! Emergency Severity
  Widget _buildSeveritySelector() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            "Emergency severity:",
            style: TextStyle(
              fontFamily: "HelveticaNeueLight",
              fontSize: 17,
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
              minWidth: 70,
            ),
            children: <Widget>[
              Text(
                "Low",
              ),
              Text(
                "Medium",
              ),
              Text("High"),
              Text("Critical"),
            ],
            onPressed: (int index) {
              setState(() {
                for (int buttonIndex = 0;
                    buttonIndex < _isSelectedSeverity.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    _severity = _severityValues[index];
                    _isSelectedSeverity[buttonIndex] = true;
                  } else {
                    _isSelectedSeverity[buttonIndex] = false;
                  }
                }
              });
            },
            isSelected: _isSelectedSeverity,
          ),
        ],
      ),
    );
  }

  //! Get Date and time widget
  Widget _buildDateTimeButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Text(
              "Emergency time:",
              style: TextStyle(
                fontFamily: "HelveticaNeueLight",
                fontSize: 17,
                color: const Color(0xff142850),
              ),
            ),
            RaisedButton(
              elevation: 5,
              color: const Color(0xff27496d),
              child: Text(
                DateFormat.yMMMMEEEEd().format(_emergencyDate) +
                    ' - ' +
                    DateFormat.jm().format(_emergencyDate),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "HelveticaNeueLight",
                  fontSize: 14,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () async {
                await _selectDate(context);
                await _selectTime(context);
              },
            ),
            Text(
              "Tap to edit",
              style: TextStyle(
                color: Colors.grey[600],
                fontFamily: "HelveticaNeueLight",
                fontSize: 12,
              ),
            ),
          ],
        ));
  }

  //! build text field for Location
  Widget _buildLocationBox() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        maxLines: null,
        maxLength: 20,
        decoration: InputDecoration(
          hintText: "Location",
          hintStyle: TextStyle(
            color: Colors.grey[700],
            fontFamily: 'HelveticaNeueLight',
            letterSpacing: 2.0,
          ),
          errorStyle: TextStyle(
            color: Colors.redAccent,
            letterSpacing: 1.0,
          ),
          fillColor: Colors.grey[1],
          filled: false,
          focusedErrorBorder: OutlineInputBorder(),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {
            _emergencyLocation = value;
          });
        },
      ),
    );
  }

  //! Name field widget
  Widget _buildName() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextFormField(
          decoration: InputDecoration(
            hintText: 'MFR Name',
            hintStyle: TextStyle(
              color: Colors.grey[700],
              fontFamily: 'HelveticaNeueLight',
              letterSpacing: 2.0,
            ),
            errorStyle: TextStyle(
              color: Colors.redAccent,
              letterSpacing: 1.0,
            ),
            fillColor: Colors.grey[1],
            filled: false,
            focusedErrorBorder: OutlineInputBorder(),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(),
          ),
          validator: (String value) {
            if (value.isEmpty) return 'Name is required!';
          },
          onSaved: (String value) {
            _primaryMfrName = value;
          }),
    );
  }

  //! build text field for additional Mfrs
  Widget _buildAdditionalMfrsBox() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        maxLines: null,
        maxLength: 200,
        decoration: InputDecoration(
          hintText: "Add backup MFR(s) info here\n\n\n",
          hintStyle: TextStyle(
            color: Colors.grey[700],
            fontFamily: 'HelveticaNeueLight',
            letterSpacing: 2.0,
          ),
          errorStyle: TextStyle(
            color: Colors.redAccent,
            letterSpacing: 1.0,
          ),
          fillColor: Colors.grey[1],
          filled: false,
          focusedErrorBorder: OutlineInputBorder(),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {
            _additionalMfrs = value;
          });
        },
      ),
    );
  }

  //! build text field for detials
  Widget _buildDetailsBox() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        maxLines: null,
        maxLength: 1000,
        decoration: InputDecoration(
          hintText: "Add details here\n\n\n\n\n\n",
          hintStyle: TextStyle(
            color: Colors.grey[700],
            fontFamily: 'HelveticaNeueLight',
            letterSpacing: 2.0,
          ),
          errorStyle: TextStyle(
            color: Colors.redAccent,
            letterSpacing: 1.0,
          ),
          fillColor: Colors.grey[1],
          filled: false,
          focusedErrorBorder: OutlineInputBorder(),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {
            _emergencyDetails = value;
          });
        },
      ),
    );
  }

  //! Build bag selector
  Widget _buildBagSelector() {
    Map<String, String> databaseNames = {
      "None": "None",
      "B1": "B1",
      "Pool": "Pool",
      "PDC": "PDC",
      "REDC": "REDC",
      "Library": "Library",
      "CS Dept.": "CsDept",
      "EMS Room": "EmsRoom",
    };
    return Padding(
      padding: EdgeInsets.all(10),
      child: DropdownButton<String>(
        value: _bagUsed,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 20,
        style: TextStyle(
          color: Colors.black,
          fontFamily: "HelveticaNeueLight",
          fontSize: 14,
        ),
        onChanged: (String newValue) {
          setState(() {
            _bagUsed = newValue;
            FocusScope.of(context).requestFocus(FocusNode());
          });
        },
        items: <String>[
          'None',
          'B1',
          'Pool',
          'PDC',
          'REDC',
          'Library',
          'CS Dept.',
          'EMS Room'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: databaseNames[value],
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
  // One time consumables
  // int _crepe = 0;
  // int _openWove = 0;
  // int _gauze = 0;
  // int _saniplast = 0;
  // int _depressors = 0;
  // int _triangBandage = 0;
  // int _gloves = 0;
  // int _faceMasks = 0;
  // int _ors = 0;

  //!Build item counter list
  Widget _buildConsumableItemCounterList() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              //Item name
              Text(
                "Crepe: ",
                style: TextStyle(
                  fontFamily: "HelveticaNeueLight",
                  fontSize: 17,
                  color: const Color(0xff142850),
                ),
              ),
              Expanded(child: SizedBox()),
              //!custom widget
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  MyCounter(
                      initialValue: _crepe,
                      min: 0,
                      max: 10,
                      onChanged: (newValue) {
                        setState(() {
                          _crepe = newValue;
                        });
                        print('updated crepe $_crepe');
                      }),
                ],
              ),
            ],
          ),
          Row(
            children: <Widget>[
              //Item name
              Text(
                "Open wove: ",
                style: TextStyle(
                  fontFamily: "HelveticaNeueLight",
                  fontSize: 17,
                  color: const Color(0xff142850),
                ),
              ),
              Expanded(child: SizedBox()),
              //!custom widget
              MyCounter(
                  initialValue: _openWove,
                  min: 0,
                  max: 10,
                  onChanged: (newValue) {
                    setState(() {
                      _openWove = newValue;
                    });
                    print('updated openWove $_openWove');
                  }),
            ],
          ),
          Row(
            children: <Widget>[
              //Item name
              Text(
                "Gauze: ",
                style: TextStyle(
                  fontFamily: "HelveticaNeueLight",
                  fontSize: 17,
                  color: const Color(0xff142850),
                ),
              ),
              Expanded(child: SizedBox()),
              //!custom widget
              MyCounter(
                  initialValue: _gauze,
                  min: 0,
                  max: 10,
                  onChanged: (newValue) {
                    setState(() {
                      _gauze = newValue;
                    });
                    print('updated gauze $_gauze');
                  }),
            ],
          ),
          Row(
            children: <Widget>[
              //Item name
              Text(
                "Saniplast ",
                style: TextStyle(
                  fontFamily: "HelveticaNeueLight",
                  fontSize: 17,
                  color: const Color(0xff142850),
                ),
              ),
              Expanded(child: SizedBox()),
              //!custom widget
              MyCounter(
                  initialValue: _saniplast,
                  min: 0,
                  max: 10,
                  onChanged: (newValue) {
                    setState(() {
                      _saniplast = newValue;
                    });
                    print('updated saniplast $_saniplast');
                  }),
            ],
          ),
          Row(
            children: <Widget>[
              //Item name
              Text(
                "Depressors: ",
                style: TextStyle(
                  fontFamily: "HelveticaNeueLight",
                  fontSize: 17,
                  color: const Color(0xff142850),
                ),
              ),
              Expanded(child: SizedBox()),
              //!custom widget
              MyCounter(
                  initialValue: _depressors,
                  min: 0,
                  max: 10,
                  onChanged: (newValue) {
                    setState(() {
                      _depressors = newValue;
                    });
                    print('updated depressors $_depressors');
                  }),
            ],
          ),
          Row(
            children: <Widget>[
              //Item name
              Text(
                "Triang bandage: ",
                style: TextStyle(
                  fontFamily: "HelveticaNeueLight",
                  fontSize: 17,
                  color: const Color(0xff142850),
                ),
              ),
              Expanded(child: SizedBox()),
              //!custom widget
              MyCounter(
                  initialValue: _triangBandage,
                  min: 0,
                  max: 10,
                  onChanged: (newValue) {
                    setState(() {
                      _triangBandage = newValue;
                    });
                    print('updated tbandage$_triangBandage');
                  }),
            ],
          ),
          Row(
            children: <Widget>[
              //Item name
              Text(
                "Gloves: ",
                style: TextStyle(
                  fontFamily: "HelveticaNeueLight",
                  fontSize: 17,
                  color: const Color(0xff142850),
                ),
              ),
              Expanded(child: SizedBox()),
              //!custom widget
              MyCounter(
                  initialValue: _gloves,
                  min: 0,
                  max: 10,
                  onChanged: (newValue) {
                    setState(() {
                      _gloves = newValue;
                    });
                    print('updated gloves $_gloves');
                  }),
            ],
          ),
          Row(
            children: <Widget>[
              //Item name
              Text(
                "Face masks: ",
                style: TextStyle(
                  fontFamily: "HelveticaNeueLight",
                  fontSize: 17,
                  color: const Color(0xff142850),
                ),
              ),
              Expanded(child: SizedBox()),
              //!custom widget
              MyCounter(
                  initialValue: _faceMasks,
                  min: 0,
                  max: 10,
                  onChanged: (newValue) {
                    setState(() {
                      _faceMasks = newValue;
                    });
                    print('updated facemasks $_faceMasks');
                  }),
            ],
          ),
          Row(
            children: <Widget>[
              //Item name
              Text(
                "ORS: ",
                style: TextStyle(
                  fontFamily: "HelveticaNeueLight",
                  fontSize: 17,
                  color: const Color(0xff142850),
                ),
              ),
              Expanded(child: SizedBox()),
              //!custom widget
              MyCounter(
                  initialValue: _ors,
                  min: 0,
                  max: 10,
                  onChanged: (newValue) {
                    setState(() {
                      _ors = newValue;
                    });
                    print('updated ors $_ors');
                  }),
            ],
          ),
        ],
      ),
    );
  }

  // // resuable consumables
  // int _pyodine = 0;
  // int _polyfax = 0;
  // int _polyfaxPlus = 0;
  // int _wintegebo = 0;
  // int _deepHeat = 0;

  //!Build item counter list
  Widget _buildReusableItemCounterList() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              //Item name
              Text(
                "Pyodine: ",
                style: TextStyle(
                  fontFamily: "HelveticaNeueLight",
                  fontSize: 17,
                  color: const Color(0xff142850),
                ),
              ),
              Expanded(child: SizedBox()),
              //!custom widget
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  MyCounter(
                      initialValue: _pyodine,
                      min: 0,
                      max: 10,
                      onChanged: (newValue) {
                        setState(() {
                          _pyodine = newValue;
                        });
                        print('updated pyodine $_pyodine');
                      }),
                ],
              ),
            ],
          ),
          Row(
            children: <Widget>[
              //Item name
              Text(
                "Polyfax: ",
                style: TextStyle(
                  fontFamily: "HelveticaNeueLight",
                  fontSize: 17,
                  color: const Color(0xff142850),
                ),
              ),
              Expanded(child: SizedBox()),
              //!custom widget
              MyCounter(
                  initialValue: _polyfax,
                  min: 0,
                  max: 10,
                  onChanged: (newValue) {
                    setState(() {
                      _polyfax = newValue;
                    });
                    print('updated polyfax $_polyfax');
                  }),
            ],
          ),
          Row(
            children: <Widget>[
              //Item name
              Text(
                "Polyfax Plus: ",
                style: TextStyle(
                  fontFamily: "HelveticaNeueLight",
                  fontSize: 17,
                  color: const Color(0xff142850),
                ),
              ),
              Expanded(child: SizedBox()),
              //!custom widget
              MyCounter(
                  initialValue: _polyfaxPlus,
                  min: 0,
                  max: 10,
                  onChanged: (newValue) {
                    setState(() {
                      _polyfaxPlus = newValue;
                    });
                    print('updated P plus $_polyfaxPlus');
                  }),
            ],
          ),
          Row(
            children: <Widget>[
              //Item name
              Text(
                "Wintogeno ",
                style: TextStyle(
                  fontFamily: "HelveticaNeueLight",
                  fontSize: 17,
                  color: const Color(0xff142850),
                ),
              ),
              Expanded(child: SizedBox()),
              //!custom widget
              MyCounter(
                  initialValue: _wintogeno,
                  min: 0,
                  max: 10,
                  onChanged: (newValue) {
                    setState(() {
                      _wintogeno = newValue;
                    });
                    print('updated wintogeno $_wintogeno');
                  }),
            ],
          ),
          Row(
            children: <Widget>[
              //Item name
              Text(
                "Deep heat: ",
                style: TextStyle(
                  fontFamily: "HelveticaNeueLight",
                  fontSize: 17,
                  color: const Color(0xff142850),
                ),
              ),
              Expanded(child: SizedBox()),
              //!custom widget
              MyCounter(
                  initialValue: _deepHeat,
                  min: 0,
                  max: 10,
                  onChanged: (newValue) {
                    setState(() {
                      _deepHeat = newValue;
                    });
                    print('updated deepHeat $_deepHeat');
                  }),
            ],
          ),
        ],
      ),
    );
  }

  // // One time consumables
  // int _crepe = 0;
  // int _openWove = 0;
  // int _gauze = 0;
  // int _saniplast = 0;
  // int _depressors = 0;
  // int _triangBandage = 0;
  // int _gloves = 0;
  // int _faceMasks = 0;
  // int _ors = 0;

  // // resuable consumables
  // int _pyodine = 0;
  // int _polyfax = 0;
  // int _polyfaxPlus = 0;
  // int _wintogeno = 0;
  // int _deepHeat = 0;

  Map<String, int> _getBagMap() {
    Map<String, int> bagMap = {};

    List<String> keys = [
      "crepe",
      "openWove",
      "gauze",
      "saniplast",
      "depressors",
      "triangBandage",
      "gloves",
      "faceMasks",
      "ors",
      "pyodine",
      "polyfax",
      "polyfaxPlus",
      "wintogeno",
      "deepHeat"
    ];
    List<int> values = [
      _crepe,
      _openWove,
      _gauze,
      _saniplast,
      _depressors,
      _triangBandage,
      _gloves,
      _faceMasks,
      _ors,
      _pyodine,
      _polyfax,
      _polyfaxPlus,
      _wintogeno,
      _deepHeat
    ];

    List<MapEntry<String, int>> entries = [];

    for (int i = 0; i < values.length; i++) {
      if (values[i] != 0) {
        entries.add(MapEntry(keys[i], values[i]));
      }
    }

    bagMap.addEntries(entries);

    return bagMap;
  }

  //loafing screen boolean
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xff27496d),
        appBar: AppBar(
          backgroundColor: const Color(0xff142850),
          title: Text(
            "Emergency Report",
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'HelveticaNeueLight',
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //!Emergency info card
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        //!heading
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Emergency Details',
                                style: TextStyle(
                                  color: const Color(0xff142850),
                                  fontFamily: "HelveticaNeueLight",
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Divider(
                          height: 10,
                        ),

                        //! Begin form for emergency Details
                        Form(
                          key: _emergencyReportKey,
                          autovalidate: _autoValidate,
                          child: Column(
                            children: <Widget>[
                              //! Sub heading
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 15, 0, 15),
                                    child: Text(
                                      "Patient Information",
                                      style: TextStyle(
                                        color: const Color(0xff142850),
                                        fontFamily: "HelveticaNeueLight",
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              _buildRollno(true),
                              _buildGenderSelector(),
                              _buildHosteliteSelector(),
                              SizedBox(
                                height: 40,
                              ),
                              Divider(height: 10),
                              //! Sub heading
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 15, 0, 15),
                                    child: Text(
                                      "Emergency Information",
                                      style: TextStyle(
                                        color: const Color(0xff142850),
                                        fontFamily: "HelveticaNeueLight",
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              _buildDateTimeButton(context),
                              _buildSeveritySelector(),
                              _buildEmergencyTypeSelector(),
                              _buildTransportUsedSelector(),
                              SizedBox(
                                height: 15,
                              ),
                              _buildLocationBox(),
                              _buildDetailsBox(),
                              SizedBox(
                                height: 40,
                              ),
                              Divider(height: 10),
                              //! Sub heading
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 15, 0, 35),
                                    child: Text(
                                      "Respondant's Information",
                                      style: TextStyle(
                                        color: const Color(0xff142850),
                                        fontFamily: "HelveticaNeueLight",
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              _buildName(),
                              _buildRollno(false),
                              _buildAdditionalMfrsBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //! Equipment Detail card
              Padding(
                padding: EdgeInsets.all(15),
                child: Card(
                  elevation: 6,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        //!Heading
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Equipment Used',
                                style: TextStyle(
                                  color: const Color(0xff142850),
                                  fontFamily: "HelveticaNeueLight",
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Divider(
                          height: 10,
                        ),

                        //! Begin Form
                        Form(
                          key: _equipmentUsedKey,
                          child: Column(
                            children: <Widget>[
                              //! Bag used
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 5, 0),
                                    child: Text(
                                      "Bag used:",
                                      style: TextStyle(
                                        fontFamily: "HelveticaNeueLight",
                                        fontSize: 20,
                                        color: const Color(0xff142850),
                                      ),
                                    ),
                                  ),
                                  _buildBagSelector(),
                                ],
                              ),
                              _bagUsed == "None"
                                  ? Container()
                                  : Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Divider(height: 10),
                                        //! Sub heading
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 15, 0, 15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "One-time Consumables",
                                                    style: TextStyle(
                                                      color: const Color(
                                                          0xff142850),
                                                      fontFamily:
                                                          "HelveticaNeueLight",
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  //! Description hint
                                                  Text(
                                                    "Increment per instance consumed",
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontFamily:
                                                          "HelveticaNeueLight",
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        _buildConsumableItemCounterList(),

                                        SizedBox(
                                          height: 10,
                                        ),
                                        Divider(height: 10),
                                        //! Sub heading
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 15, 0, 15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Reusable Consumables",
                                                    style: TextStyle(
                                                      color: const Color(
                                                          0xff142850),
                                                      fontFamily:
                                                          "HelveticaNeueLight",
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  //! Description hint
                                                  Text(
                                                    "Increment only if an item needs replacement",
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontFamily:
                                                          "HelveticaNeueLight",
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        _buildReusableItemCounterList(),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //! submit button
              !_isLoading
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 100),
                      child: RaisedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'HelveticaNeueBold',
                                fontSize: 16,
                                letterSpacing: 1.0,
                              )),
                        ),
                        color: const Color(0xFF73CDE8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onPressed: () async {
                          //!submit
                          if (!_emergencyReportKey.currentState.validate() ||
                              !_equipmentUsedKey.currentState.validate()) {
                            return;
                          }
                          //translate boolean arrays
                          _emergencyReportKey.currentState.save();
                          _equipmentUsedKey.currentState.save();
                          // print(_patientRollNo);
                          // print(_patientGender);
                          // print(_patientIsHostelite);
                          // print('');
                          // print(_emergencyDate);
                          // print(_severity);
                          // print(_emergencyType);
                          // print(_transportUsed);
                          // print(_emergencyDetails);
                          // print('');
                          // print(_primaryMfrName);
                          // print(_primaryMfrRollNo);
                          // print(_additionalMfrs);
                          // print('-------------');
                          // print(_bagUsed);
                          // _bagUsed == "None" ? print("No items used") : print(_getBagMap());
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            await Firestore.instance
                                .collection('ReportedEmergencies')
                                .document(_emergencyDate.toString())
                                .setData({
                              'patientRollNo': _patientRollNo,
                              'patientGender': _patientGender,
                              'patientIsHostelite': _patientIsHostelite,
                              'date': _emergencyDate,
                              'severity': _severity,
                              'type': _emergencyType,
                              'transportUsed': _transportUsed,
                              'details': _emergencyDetails,
                              'primaryMfrRollNo': _primaryMfrRollNo,
                              'primaryMfrName': _primaryMfrName,
                              'additionalMfrs': _additionalMfrs,
                              'location': _emergencyLocation,
                              'bagUsed': _bagUsed,
                              'equipmentUsed':
                                  _bagUsed == "None" ? null : _getBagMap(),
                            });

                            setState(() {
                              _isLoading = false;
                            });

                            //! Showing failed dialog
                            await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                title: Text(
                                  "Report Submitted!",
                                  style: TextStyle(
                                    fontFamily: 'HelveticaNeueLight',
                                    letterSpacing: 2.0,
                                    fontSize: 20,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                actions: <Widget>[
                                  Center(
                                    child: Padding(
                                      //alignment: Alignment.bottomLeft,
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: FlatButton(
                                        child: Text(
                                          'OK',
                                          style: TextStyle(
                                            fontFamily: 'HelveticaNeueLight',
                                            //fontWeight: FontWeight.bold,
                                            letterSpacing: 2.0,
                                            fontSize: 20,
                                            color: const Color(0xff1a832a),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            Navigator.of(context).pop();
                          } catch (e) {
                            setState(() {
                              _isLoading = false;
                            });
                            print(e);
                            //! Showing failed dialog
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                title: Text(
                                  "Failed to submit!",
                                  style: TextStyle(
                                    fontFamily: 'HelveticaNeueLight',
                                    letterSpacing: 2.0,
                                    fontSize: 20,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                actions: <Widget>[
                                  Center(
                                    child: Padding(
                                      //alignment: Alignment.bottomLeft,
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: FlatButton(
                                        child: Text(
                                          'Try Again',
                                          style: TextStyle(
                                            fontFamily: 'HelveticaNeueLight',
                                            //fontWeight: FontWeight.bold,
                                            letterSpacing: 2.0,
                                            fontSize: 20,
                                            color: const Color(0xffee0000),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          setState(() {
                            _isLoading = false;
                          });
                        },
                      ),
                    )
                  : //! OR
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 100),
                      child: SpinKitThreeBounce(
                        color: Colors.grey[100],
                        size: 30,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
