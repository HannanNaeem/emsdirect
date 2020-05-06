import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/mfr_list_card.dart';
import 'package:ems_direct/services/ops_database.dart';

class MfrList extends StatefulWidget {
  @override
  _MfrListState createState() => _MfrListState();
}

class _MfrListState extends State<MfrList> {
  var mfrList;
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
          ? Loading()
          : Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
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
