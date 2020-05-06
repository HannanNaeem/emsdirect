import 'package:flutter/material.dart';
import 'package:ems_direct/senior_mfr_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/shared/loading.dart';

class SeniorMfrData{
  String name;
  String contact;
  String rollNo;
  String gender;
  bool isOccupied;


  SeniorMfrData(this.name, this.contact, this.rollNo, this.gender, this.isOccupied);
}

class SeniorMfrs extends StatefulWidget {
  @override
  _SeniorMfrsState createState() => _SeniorMfrsState();
}

class _SeniorMfrsState extends State<SeniorMfrs> {

  var seniorMfrList = List<SeniorMfrData>();
  final databaseReference = Firestore.instance;
  bool populate = false;

  @override
  void initState() {
    super.initState();
    _getSeniorMfr();
  }

  //get documents of senior MFRs
  _getSeniorMfr(){
    databaseReference.collection('Mfr')
        .where('isSenior', isEqualTo: true)
        .getDocuments().then((QuerySnapshot snapshot) =>
        _makeList(snapshot)
    );
  }

  //make list of the seniorMfrs from snapshot
  _makeList(QuerySnapshot snapshot){
    setState(() {
      snapshot.documents.forEach((document) =>
          seniorMfrList.add(SeniorMfrData(document.data['name'], document.data['contact'], 
          document.documentID, document.data['gender'], document.data['isOccupied'])));
    });
    populate = true;
  }


  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return Scaffold(
      backgroundColor: const Color(0xff27496d),
      appBar: AppBar(
        backgroundColor: const Color(0xff142850),
        title: Text(
          'Senior MFRs',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'HelveticaNeueLight',
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: populate == false
        ? Loading()
        : Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: seniorMfrList == null ? 0: seniorMfrList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 105,
                        ),
                        child: SeniorMfrCard(
                          seniorMfrList[index].name,
                          seniorMfrList[index].contact,
                          seniorMfrList[index].rollNo,
                          seniorMfrList[index].gender,
                          seniorMfrList[index].isOccupied,
                            ),
                      ),
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
