import 'package:flutter/material.dart';
import 'package:ems_direct/available_mfr_card.dart';
import 'package:ems_direct/services/ops_database.dart';
import 'package:provider/provider.dart';
import 'package:ems_direct/models/emergency_models.dart';

class MfrData{
  String name;
  String contact;
  String rollNo;
  String gender;
  bool isOccupied;

  MfrData(this.name,this.contact,this.rollNo,this.gender,this.isOccupied);
}



class AvailableMfrsList extends StatefulWidget {
  @override
  _AvailableMfrsListState createState() => _AvailableMfrsListState();
}

class _AvailableMfrsListState extends State<AvailableMfrsList> {
  var numberData = AvailableMfrsData.data;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return StreamProvider<List<AvailableMfrs>>.value(
      value: OpsDatabaseService().availableMfrStream,
      child: MakeList(),
    );
  }
}


class MakeList extends StatefulWidget {
  @override
  _MakeListState createState() => _MakeListState();
}

class _MakeListState extends State<MakeList> {

  @override
  Widget build(BuildContext context) {
    List<MfrData> _mfrList = [];
    //_mfrList.add(MfrData('name','contact', 'gender', 'rollno', true));
    var _availableMfrList = Provider.of<List<AvailableMfrs>>(context);

    void populateList(){
      for(var i = 0; i < _availableMfrList.length; i++){
        _mfrList.add(MfrData(_availableMfrList[i].name, _availableMfrList[i].contact, _availableMfrList[i].rollNo, _availableMfrList[i].gender, _availableMfrList[i].isOccupied));
      }
    }

    if(_availableMfrList != null)
      {
        populateList();
      }

    return Scaffold(
      backgroundColor: const Color(0xff27496d),
      appBar: AppBar(
        backgroundColor: const Color(0xff142850),
        title: Text(
          'Available MFRs',
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
                itemCount: _mfrList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 105,
                      ),
                      child: AvailableMfrCard(
                        _mfrList[index].name,
                        _mfrList[index].contact,
                        _mfrList[index].rollNo,
                        _mfrList[index].gender,
                        _mfrList[index].isOccupied,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );;
  }
}

