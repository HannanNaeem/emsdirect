import 'package:flutter/material.dart';

class Records extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    print(height);
    print(width);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[800],
        title: Text(
          'Records',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'HelveticaNeueBold',
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              width: width,
              color: Colors.cyan[300],
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
                              child: AspectRatio(
                                aspectRatio: 2 / 2.25,
                                child: Container(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints.expand(),
                                    child: Ink.image(
                                      image:
                                          AssetImage('assets/emergencies.png'),
                                      fit: BoxFit.cover,
                                      child: InkWell(
                                        onTap: () {
                                          print('emergencies');
                                        },
                                      ),
                                    ),
                                  ),
                                ),
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
                              child: Text('Card 2'),
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
              color: Colors.cyan[100],
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
                              child: Text('Card 1'),
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
                              child: Text('Card 2'),
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
