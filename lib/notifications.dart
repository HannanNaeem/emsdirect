import 'package:flutter/material.dart';
import 'package:ems_direct/notification_data.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  var notificationData = NotificationData.Data;
  var hello = NotificationData.hello;

  Widget _GenerateList(String category, var data) {
    var color;
    if (category == 'records') {
      color = Colors.green;
    } else {
      color = Colors.red;
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  setState(() {
                    data.removeAt(index);
                  });
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('Notification removed')));
                },
                //background: Container(color: Colors.red),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 100,
                    ),
                    child: Card(
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
                                  padding: EdgeInsets.fromLTRB(10, 29, 0, 20),
                                  child: Icon(
                                    Icons.fiber_manual_record,
                                    color: color,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 30, 0, 20),
                                    child: Container(
                                      child: Text(
                                        data[index]['text'],
                                        style: TextStyle(
                                          //color: const Color(0xff3596b5),
                                          fontSize: 17,
                                          fontFamily: 'HelveticaNeue',
                                          //fontWeight: FontWeight.bold,
                                          //letterSpacing: 2,
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
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                              child: IconButton(
                                color: Colors.grey[700],
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  print('Delete notification');
                                  setState(() {
                                    data.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return Scaffold(
      body: Container(
        child: _GenerateList('testing', hello),
      ),
    );
  }
}
