import 'package:flutter/material.dart';

class Records extends StatelessWidget {
  //This functions makes the cards on the screen since each card follows the same template
  Widget _GenerateCard(String title, String imageFileName, var height) {
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
            },
            iconSize: height / 9,
          ),
          Text(
            title,
            style: TextStyle(
              color: const Color(0xff3596b5),
              fontSize: 20,
              fontFamily: 'HelveticaNeue',
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
      drawer: Drawer(
        elevation: 20.0,
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xff3596b5),
        title: Text(
          'Records',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'HelveticaNeue',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
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
                                  'assets/emergencies.png', height)),
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
                                  'Equipment bags', 'assets/bags.png', height)),
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
                                  'Profiles', 'assets/profile.png', height)),
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
                                    'assets/inventory.png', height))),
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
