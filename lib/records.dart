import 'package:flutter/material.dart';
import 'package:ems_direct/pages/EquipmentBags.dart';
class Records extends StatelessWidget {
  //This functions makes the cards on the screen since each card follows the same template
  Widget _GenerateCard(String title, String imageFileName, var height, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Image(
              image: AssetImage(imageFileName),
            ),
            onPressed: () {
              print(title);
              if(title == 'Equipment bags'){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EquipmentBags()));
              }
            },
            iconSize: height / 9,
          ),
          Text(
            title,
            style: TextStyle(
              color: const Color(0xff142850),
              fontSize: 16,
              letterSpacing: 1,
              fontFamily: 'HelveticaNeueLight',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    final height = screenSize.height;

    return Scaffold(
      backgroundColor: const Color(0xff27496d),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              width: width,
              //color: Colors.cyan[300],
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 10, 10),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: AspectRatio(
                          aspectRatio: 2 / 2.25,
                          child: Container(
                              child: _GenerateCard('Emergencies',
                                  'assets/emergencies.png', height, context)),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 20, 10),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: AspectRatio(
                          aspectRatio: 2 / 2.25,
                          child: Container(
                              child: _GenerateCard(
                                  'Equipment bags', 'assets/bags.png', height, context)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              //color: Colors.cyan[100],
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: AspectRatio(
                          aspectRatio: 2 / 2.25,
                          child: Container(
                              child: _GenerateCard(
                                  'Profiles', 'assets/profile.png', height, context)),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: AspectRatio(
                            aspectRatio: 2 / 2.25,
                            child: Container(
                                child: _GenerateCard('Inventory',
                                    'assets/inventory.png', height, context))),
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
