import 'package:flutter/material.dart';
import 'package:ems_direct/available_mfr_card.dart';
import 'package:ems_direct/services/ops_database.dart';
import 'package:provider/provider.dart';
import 'package:ems_direct/models/emergency_models.dart';
import 'package:ems_direct/shared/loading.dart';

//---------------------------------------------
// Contains the widget tree for the available mfrs screen
// -------------------------------------------



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

  @override
  Widget build(BuildContext context) {


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


    bool populate = false;
    List<MfrData> _mfrList = [];
    var _availableMfrList = Provider.of<List<AvailableMfrs>>(context);

    void populateList(){
      for(var i = 0; i < _availableMfrList.length; i++){
        _mfrList.add(MfrData(_availableMfrList[i].name, _availableMfrList[i].contact, _availableMfrList[i].rollNo, _availableMfrList[i].gender, _availableMfrList[i].isOccupied));
      }
      populate = true;
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
      body: populate == false
        ? Loading()
        : Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: _mfrList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
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
    );
  }
}

