import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/presentation/custom_icons.dart' as CustomIcons;
import 'package:progress_dialog/progress_dialog.dart';

class MfrProfile extends StatefulWidget {
  final mfr;
  MfrProfile({this.mfr});
  @override
  _MfrProfileState createState() => _MfrProfileState();
}

class _MfrProfileState extends State<MfrProfile> {
  var _contact;

  final GlobalKey<FormState> _contactKey = GlobalKey<FormState>();

  //this function determines the gender label from the recieved MFR profile
  String gender(var mfr) {
    if (mfr.gender == 'F') {
      return 'Female';
    } else if (mfr.gender == 'M') {
      return 'Male';
    } else {
      return 'Other';
    }
  }

  //this function returns the textfield widget which takes in the edited contact number
  //this also includes validation of the input
  Widget _buildContact() {
    return Form(
      key: _contactKey,
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
              if (value.isEmpty) return 'Contact number is required!';
              if (!RegExp(r"^[0-9]{11}$").hasMatch(value))
                return 'Invalid number';
            },
            onSaved: (String value) {
              _contact = value;
            }),
      ),
    );
  }

  //this function returns the alert dialog widget which comes when the user chooses the option to
  //edit contact information
  //this function takes in the ProgressDialog object, to let the user know that the entered information is being updated
  Widget _buildDialog(ProgressDialog pr) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: Container(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter new contact number below:',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'HelveticaNeueLight',
                  color: Colors.black,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 20),
              _buildContact(),
              SizedBox(height: 20),
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
                        fontSize: 20,
                        color: const Color(0xff1a832a),
                      ),
                    ),
                    onPressed: () async {
                      //validation prompted once input is entered
                      if (!(_contactKey.currentState.validate())) {
                        return;
                      }
                      _contactKey.currentState.save();

                      pr.show();

                      //update to the database
                      try {
                        await Firestore.instance
                            .collection('Mfr')
                            .document(widget.mfr.rollNo)
                            .updateData({'contact': _contact});
                      } catch (e) {
                        print(e.toString());
                      }
                      pr.hide();
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'HelveticaNeueLight',
                        letterSpacing: 2,
                        fontSize: 20,
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
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //setting the contact number variable from the MFR profile
    _contact = widget.mfr.contact;
  }

  @override
  Widget build(BuildContext context) {
    //getting screen dimensions
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    final height = screenSize.height;

    //setting up the ProgressDialog based on the context above
    ProgressDialog pr =
        new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: 'Updating info...',
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

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(
            child: Container(
              color: const Color(0xff142850),
              height: height * 0.4,
              //width: width,
              child: Stack(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SafeArea(
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Center(
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 60,
                          //backgroundImage: AssetImage('assets/ems_logo.png'),
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            color: const Color(0xff27496d),
                            size: 100,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          widget.mfr.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'HelveticaNeueLight',
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: Container(
              height: height * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 20),
                    child: Text(
                      'Profile Info',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'HelveticaNeueLight',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: width / 7),
                    child: Container(
                      //color: Colors.amber,
                      height: 50,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 5,
                            child: Icon(
                              CustomIcons.MyFlutterApp.wc,
                              color: const Color(0xff142850),
                              size: 35,
                            ),
                          ),
                          Positioned(
                            left: 45,
                            child: Text(
                              'Gender: ',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'HelveticaNeueLight',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 55,
                            top: 25,
                            child: Text(
                              gender(widget.mfr),
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'HelveticaNeueLight',
                                color: Colors.black,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: width / 7),
                    child: Container(
                      //color: Colors.amber,
                      height: 50,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 5,
                            child: Icon(
                              Icons.email,
                              color: const Color(0xff142850),
                              size: 35,
                            ),
                          ),
                          Positioned(
                            left: 45,
                            child: Text(
                              'Email: ',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'HelveticaNeueLight',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 55,
                            top: 25,
                            child: Text(
                              "${widget.mfr.rollNo}@lums.edu.pk",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'HelveticaNeueLight',
                                color: Colors.black,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: width / 7),
                    child: Container(
                      //color: Colors.amber,
                      height: 50,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 5,
                            child: Icon(
                              Icons.call,
                              color: const Color(0xff142850),
                              size: 35,
                            ),
                          ),
                          Positioned(
                            left: 45,
                            child: Text(
                              'Contact: ',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'HelveticaNeueLight',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 55,
                            top: 25,
                            child: Text(
                              _contact,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'HelveticaNeueLight',
                                color: Colors.black,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 5,
                              right: 55,
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.grey[700],
                                  size: 35,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return _buildDialog(pr);
                                      });
                                },
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
