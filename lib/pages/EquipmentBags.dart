import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ems_direct/pages/equipment_bag_details.dart';

class EquipmentBags extends StatefulWidget {
  @override
  EquipmentBagsState createState() => new EquipmentBagsState();
}

class EquipmentBagsState extends State<EquipmentBags> {
  // //This list contains the name of the bags which will be displayed on the screen.
  var equipmentBagNames = [
    'B1 BAG',
    'CS DEPT. BAG',
    'EMS ROOM BAG',
    'LIBRARY BAG',
    'PDC BAG',
    'POOL BAG',
    'REDC BAG'
  ];

  //This list contains the name of the bags in the database which will be sent
  // to the class 'BagDetails' to display the contents of the bag.
  var dbName = ['B1', 'CsDept', 'EmsRoom', 'Library', 'PDC', 'Pool', 'REDC'];

  @override
  Widget build(BuildContext context) {
    // Used to make screen responsive.
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
              child: Column(children: <Widget>[
                Expanded(
                    // iterating through the equipment names to display cards for each of them
                    child: ListView.builder(
                        itemCount: equipmentBagNames == null
                            ? 0
                            : equipmentBagNames.length,
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
                                      height: 0.1 * height,
                                      width: 0.7 * width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                      ),
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 25, 0, 0),
                                        child: Column(children: <Widget>[
                                          Text(
                                            equipmentBagNames[index],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: const Color(0xff142850),
                                              fontSize: 14,
                                              fontFamily: 'HelveticaNeueLight',
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ]),
                                      )),
                                  onPressed: () {
                                    // After clicking the corresponding card, the data of that bag is passed to to next screen
                                    // so that the contents in the bag can be displayed and edited.
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BagDetails(
                                                dbName[index],
                                                equipmentBagNames[index])));
                                  },
                                ),
                              ));
                        }))
              ]),
            )));
  }
}
