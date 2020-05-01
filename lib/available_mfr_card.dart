import 'package:flutter/material.dart';

class AvailableMfrCard extends StatefulWidget {
  String text;
  String category;
  String time;

  AvailableMfrCard(String text, String category, String time) {
    this.text = text;
    this.category = category;
    this.time = time;
  }

  @override
  _AvailableMfrCardState createState() => _AvailableMfrCardState();
}

class _AvailableMfrCardState extends State<AvailableMfrCard> {
  Color GenerateColor(String category) {
    if (category == 'Equipment Restock' || category == 'Bag Restock') {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = GenerateColor(widget.category);

    return Card(
      elevation: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(6, 24, 0, 20),
                  child: Icon(
                    Icons.fiber_manual_record,
                    color: color,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 25, 0, 20),
                    child: Container(                     
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(                        
                            widget.category,
                            style: TextStyle(
                              color: const Color(0xffee0000),
                              fontSize: 20,
                              fontFamily: 'HelveticaNeueLight',
                            ),
                          ),
                          Text(
                            widget.text,
                            style: TextStyle(
                              color: const Color(0xff142850),
                              fontSize: 14,
                              fontFamily: 'HelveticaNeueLight',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0,3,3,0),
                child: Text(
                  widget.time,
                  style: TextStyle(
                    color: const Color(0xff142850),
                    fontSize: 12,
                    fontFamily: 'HelveticaNeueLight',
                  ),
                ),
              ),
            ),
          ),
//           Flexible(
//             flex: 1,
//             child: IconButton(
//               color: Colors.grey[700],
//               icon: Icon(Icons.cancel),
//               onPressed: () {
//                 print('Delete AvailableMfr');
// //                setState(() {
// //                  data.removeAt(index);
// //                });
//               },
//             ),
//           ),
        ],
      ),
    );
  }
}
