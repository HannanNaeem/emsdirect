import 'package:flutter/material.dart';
import 'package:ems_direct/senior_mfr_card.dart';



class SeniorMfrs extends StatefulWidget {
  @override
  _SeniorMfrsState createState() => _SeniorMfrsState();
}

class _SeniorMfrsState extends State<SeniorMfrs> {
  var numberData = SeniorMfrsData.data;

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
          'Senior MFRs',
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
                itemCount: numberData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 105,
                      ),
                      child: SeniorMfrCard(
                        numberData[index]['name'],
                        numberData[index]['contact'],
                        numberData[index]['rollNo'],
                        numberData[index]['gender'],
                        numberData[index]['isOccupied'],
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
