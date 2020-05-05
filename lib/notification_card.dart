import 'package:flutter/material.dart';

class NotificationCard extends StatefulWidget {
  String text;
  String category;
  String time;
  String severity;
  String patientDetails;

  NotificationCard(String text, String category, String time, String severity, String patientDetails) {
    this.text = text;
    this.category = category;
    this.time = time;
    this.severity = severity;
    this.patientDetails = patientDetails;
  }

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  Color GenerateColor(String category) {
    if (category == 'Restock Needed!' || category == 'Bag Restock') {
      return Colors.orange[800];
    } else {
      return Colors.red;
    }
  }

  Color _severityToColor(String inSeverity){
    switch (inSeverity) {
      case "low" : {return Colors.yellow[700];}
      case "medium" : {return Colors.amber[800];}
      case "high" : {return Colors.orange[900];}
      default: {return Colors.red[800];}
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
                //! Icon
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
                          //! heading
                          Text(                        
                            widget.category,
                            style: TextStyle(
                              color: widget.category == "Restock Needed!" ? Colors.orange[800] : const Color(0xffee0000),
                              fontSize: 20,
                              fontFamily: 'HelveticaNeueLight',
                            ),
                          ),
                          //! text           
                          widget.category != "Restock Needed!" ? 
                          Column(
                            children: <Widget>[
                              //! emergency text
                              SizedBox(height: 5),
                              Text(
                                widget.text,
                                style: TextStyle(
                                  color: const Color(0xff142850),
                                  fontSize: 14,
                                  fontFamily: 'HelveticaNeueLight',
                                ),
                              ),
                              SizedBox(height: 10,),
                              //! bubble for severity and patient details
                              Row(
                                children: <Widget>[
                                  //! Patient Details
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        widget.patientDetails,
                                        style: TextStyle(
                                          color: const Color(0xff142850),
                                          fontSize: 14,
                                          fontFamily: 'HelveticaNeueLight',
                                        ),
                                      ),
                                    ],
                                  ),
                                  //! bubble
                                  Expanded(
                                    child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 15, 0, 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: _severityToColor(widget.severity)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(10,5,10,5),
                                            child: Text(
                                              widget.severity[0].toUpperCase() + widget.severity.substring(1),
                                              style: TextStyle(
                                                fontFamily: "HelveticaNeueLight",
                                                fontSize: 15,
                                                color: Colors.white,
                                              )
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                          :                  
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
