import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/services/ops_database.dart';
import 'package:ems_direct/pages/equipment_bag_details.dart';
class EquipmentBags extends StatefulWidget {
  @override
  EquipmentBagsState createState() => new EquipmentBagsState();
}


class EquipmentBagsState extends State<EquipmentBags> {
  var _equipmentBagList;
  bool done = true;
  @override

  var _equipmentBagNames = ['B1 BAG', 'POOL BAG', 'PDC BAG', 'REDC BAG', 'LIBRARY BAG', 'CS DEPT. BAG', 'EMS ROOM BAG'];
  var indexList = ['B1 Bag', 'Pool Bag', 'PDC Bag', 'REDC Bag', 'Library Bag', 'CS Dept Bag', 'EMS Room Bag'];
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff142850),
            title: Text(
              'Equipment Bags',
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
          body: Container(
              child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                          itemCount: _equipmentBagNames == null
                              ? 0
                              : _equipmentBagNames.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 20, 0),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: 100,
                                  minWidth: 100,
                                ),
                                child: CupertinoButton(
                                  child: Container(
                                    height: 0.1*height,
                                    width: 0.7*width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                                      child: Column(
                                          children: <Widget>[
                                            Text(
                                              _equipmentBagNames[index],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: const Color(0xff142850),
                                                fontSize: 14,
                                                fontFamily: 'HelveticaNeueLight',
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ]
                                      ),
                                    )
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BagDetails(indexList[index], _equipmentBagNames[index])));

                                  },
                                ),
                              )
                            );
                          }
                      )
                    )
                  ]
              ),
          )
        )
    );
  }
}