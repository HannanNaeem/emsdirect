import 'package:flutter/material.dart';

class Records extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    final height = screenSize.height;

    print(height);
    print(width);

    return Scaffold(
      drawer: Drawer(),
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
                            child: Card(
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
                                      image:
                                          AssetImage('assets/emergencies.png'),
                                    ),
                                    onPressed: () {
                                      print('Emergencies');
                                    },
                                    iconSize: height / 9,
                                  ),
                                  Text(
                                    'Emergencies',
                                    style: TextStyle(
                                      color: const Color(0xff3596b5),
                                      fontSize: 20,
                                      fontFamily: 'HelveticaNeue',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                            child: Card(
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
                                      image: AssetImage('assets/bags.png'),
                                    ),
                                    onPressed: () {
                                      print('Equipment bags');
                                    },
                                    iconSize: height / 9,
                                  ),
                                  Text(
                                    'Equipment Bags',
                                    style: TextStyle(
                                      color: const Color(0xff3596b5),
                                      fontSize: 20,
                                      fontFamily: 'HelveticaNeue',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                            child: Card(
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
                                      image: AssetImage('assets/profile.png'),
                                    ),
                                    onPressed: () {
                                      print('Profiles');
                                    },
                                    iconSize: height / 10,
                                  ),
                                  Text(
                                    'MFR Profiles',
                                    style: TextStyle(
                                      color: const Color(0xff3596b5),
                                      fontSize: 20,
                                      fontFamily: 'HelveticaNeue',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                            child: Card(
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
                                      image: AssetImage('assets/inventory.png'),
                                    ),
                                    onPressed: () {
                                      print('Inventory');
                                    },
                                    iconSize: height / 9,
                                  ),
                                  Text(
                                    'Inventory',
                                    style: TextStyle(
                                      color: const Color(0xff3596b5),
                                      fontSize: 20,
                                      fontFamily: 'HelveticaNeue',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
