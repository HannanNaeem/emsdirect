import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class EmergencyReportMfr extends StatefulWidget {
  @override
  _EmergencyReportMfrState createState() => _EmergencyReportMfrState();
}

class _EmergencyReportMfrState extends State<EmergencyReportMfr> {

  final GlobalKey<FormState> _emergencyReportKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _equipmentUsedKey = GlobalKey<FormState>();

  String _patientRollNo; //
  String _patientGender; //
  DateTime _emergencyDate = DateTime.now(); //
  String _primaryMfrRollNo; //
  String _primaryMfrName; //
  String _additionalMfrs; //
  String _severity; //
  bool _patientIsHostelite;//
  String _emergencyType; //
  String _emergencyLocation;
  bool _transportUsed = false; //
  String _emergencyDetails; //

  String _bagUsed = "None";

  bool _autoValidate = false;
  List<bool> _isSelectedPatientGender = [false,false,true];
  List<bool> _isSelectedSeverity = [true,false,false,false];
  List<bool> _isSelectedHostelite = [true,false];
  List<bool> _isSelectedEmergencyType = [true,false];
  List<bool> _isSelectedTransportUsed = [true,false];


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
            if(isPatient)
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

    if(pickedDate != null && pickedDate != _emergencyDate){
      setState(() {
        _emergencyDate = pickedDate;
      });
    }

  }

   //! Get time Fucntion
  Future<Null> _selectTime(BuildContext context) async {

    final TimeOfDay pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if(pickedTime != null){
      setState(() {
        _emergencyDate = DateTime(_emergencyDate.year,_emergencyDate.month,_emergencyDate.day,pickedTime.hour,pickedTime.minute);
        print(_emergencyDate.toString());
      });
    }

  }

  //! Patient gender
  Widget _buildGenderSelector() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[

          Text("Patient gender:",
            style:TextStyle(
              fontFamily: "HelveticaNeueLight",
              fontSize: 17,
              color: const Color(0xff142850),
            ) ,
          ),
          SizedBox(height: 7,),
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
              Text(
                "Other"
                ),
            ],

            onPressed: (int index) {
              setState(() {

                for (int buttonIndex = 0; buttonIndex < _isSelectedPatientGender.length; buttonIndex++) {
                  if (buttonIndex == index) {
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

          Text("Patient type:",
            style:TextStyle(
              fontFamily: "HelveticaNeueLight",
              fontSize: 17,
              color: const Color(0xff142850),
            ) ,
          ),
          SizedBox(height: 7,),
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

                for (int buttonIndex = 0; buttonIndex < _isSelectedHostelite.length; buttonIndex++) {
                  if (buttonIndex == index) {
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

  //! Emergency Type = trauma or medical
  Widget _buildTransportUsedSelector() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[

          Text("Was transport used?",
            style:TextStyle(
              fontFamily: "HelveticaNeueLight",
              fontSize: 17,
              color: const Color(0xff142850),
            ) ,
          ),
          SizedBox(height: 7,),
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

                for (int buttonIndex = 0; buttonIndex < _isSelectedTransportUsed.length; buttonIndex++) {
                  if (buttonIndex == index) {
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

          Text("Emergency type:",
            style:TextStyle(
              fontFamily: "HelveticaNeueLight",
              fontSize: 17,
              color: const Color(0xff142850),
            ) ,
          ),
          SizedBox(height: 7,),
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

                for (int buttonIndex = 0; buttonIndex < _isSelectedEmergencyType.length; buttonIndex++) {
                  if (buttonIndex == index) {
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

          Text("Emergency severity:",
            style:TextStyle(
              fontFamily: "HelveticaNeueLight",
              fontSize: 17,
              color: const Color(0xff142850),
            ) ,
          ),
          SizedBox(height: 7,),
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
              Text(
                "High"
              ),
              Text(
                "Critical"
              ),
            ],

            onPressed: (int index) {
              setState(() {

                for (int buttonIndex = 0; buttonIndex < _isSelectedSeverity.length; buttonIndex++) {
                  if (buttonIndex == index) {
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
  Widget _buildDateTimeButton(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text("Emergency time:",
            style:TextStyle(
              fontFamily: "HelveticaNeueLight",
              fontSize: 17,
              color: const Color(0xff142850),
            ) ,
            ),
          RaisedButton(
              elevation: 5,
              color: const Color(0xff27496d),
              child: Text(
                DateFormat.yMMMMEEEEd().format(_emergencyDate) +' - ' + DateFormat.jm().format(_emergencyDate) ,
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
      )
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
              color: Colors.amber,
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
        onChanged: (value){
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
        onChanged: (value){
          setState(() {
            _emergencyDetails = value;
          });
          
        },

      ),
    );
  }


  //! Build bag selector
  Widget _buildBagSelector() {
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
        onChanged: (String newValue){
          setState(() {
            _bagUsed = newValue;
          });
        },
        items: <String>['None','B1','Pool','PDC','REDC','Library','CS Dept.','EMS Room']
          .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          })
          .toList(),

      ),
    );
  }

  //!Build item counter list
  Widget _buildItemCounterList() {
    return Container();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    ],),
                  ),

                  Divider(height: 10,),

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
                              padding: const EdgeInsets.fromLTRB(8, 15, 0, 15),
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
                        SizedBox(height: 40,),
                        Divider(height: 10),
                        //! Sub heading
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 15, 0, 15),
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
                        _buildDetailsBox(),
                        SizedBox(height: 40,),
                        Divider(height: 10),
                        //! Sub heading
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 15, 0, 35),
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

              ],),
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
                children: <Widget> [
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
                    ],),
                  ),

                  Divider(height: 10,),

                  //! Begin Form
                  Form(
                    key: _equipmentUsedKey,
                    child: Column(
                      children: <Widget>[
                        // //! Sub heading
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: <Widget>[
                        //     Padding(
                        //       padding: const EdgeInsets.fromLTRB(8, 15, 0, 15),
                        //       child: Text(
                        //         "Bag information",
                        //         style: TextStyle(
                        //           color: const Color(0xff142850),
                        //           fontFamily: "HelveticaNeueLight",
                        //           fontSize: 20,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 5, 0),
                              child: Text("Bag used:",
                                style:TextStyle(
                                  fontFamily: "HelveticaNeueLight",
                                  fontSize: 17,
                                  color: const Color(0xff142850),
                                ) ,
                              ),
                            ),
                            _buildBagSelector(),
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
      ],
      ),
      ),
    );
  }
}