import 'package:flutter/material.dart';
import 'package:ems_direct/pages/emergency_numbers_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NumbersData{
  String _name;
  String _contact;

  NumbersData(String name, String contact){_name =  name; _contact = contact;}
}


class EmergencyNumbers extends StatefulWidget {
  @override
  _EmergencyNumbersState createState() => _EmergencyNumbersState();
}

class _EmergencyNumbersState extends State<EmergencyNumbers> {
  //var numberData = EmergencyNumbersData.data;
  List<NumbersData> _numberList;
  final databaseReference = Firestore.instance;

  @override
  void initState() {
    super.initState();
    _getEmergencyNumbers();
  }

  _getEmergencyNumbers(){
    databaseReference.collection('EmergencyNumbers')
        .document('Numbers')
        .get().then((DocumentSnapshot snapshot) =>
        _makeList(snapshot));
  }

  _makeList(DocumentSnapshot snapshot){
    _numberList.add(NumbersData('EMS1', snapshot.data['ems1']));
    _numberList.add(NumbersData('EMS2', snapshot.data['ems2']));
    _numberList.add(NumbersData('EMS3', snapshot.data['ems3']));
    _numberList.add(NumbersData('EMS4', snapshot.data['ems4']));
    _numberList.add(NumbersData('lUMS', snapshot.data['lums']));
    _numberList.add(NumbersData('HAWC', snapshot.data['hawc']));
    _numberList.add(NumbersData('Security Office', snapshot.data['securityOffice']));
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
          'Emergency Numbers',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'HelveticaNeueLight',
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _numberList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 80,
                      ),
                      child: EmergencyNumberCard(
                        _numberList[index]._name,
                        _numberList[index]._contact
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
