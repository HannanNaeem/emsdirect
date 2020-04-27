import 'package:flutter/material.dart';

class NotificationCard extends StatefulWidget {
  String text;
  String category;
  String time;

  NotificationCard(String text, String category, String time) {
    this.text = text;
    this.category = category;
    this.time = time;
  }

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  Color GenerateColor(String category) {
    if (category == 'testing') {
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
            flex: 6,
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
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 25, 0, 20),
                    child: Container(
                      child: Text(
                        widget.text,
                        style: TextStyle(
                          color: const Color(0xff142850),
                          fontSize: 14,
                          fontFamily: 'HelveticaNeueLight',
                        ),
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
//           Flexible(
//             flex: 1,
//             child: IconButton(
//               color: Colors.grey[700],
//               icon: Icon(Icons.cancel),
//               onPressed: () {
//                 print('Delete notification');
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
