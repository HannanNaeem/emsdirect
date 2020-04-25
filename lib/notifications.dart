import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/notification_data.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  var notificationData = NotificationData.Data;
  var hello = NotificationData.hello;
  var timeList = NotificationData.timeList;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    print('triggered');

    


    TimeOfDay timeOfDay = TimeOfDay.fromDateTime(DateTime.now());
    String res = timeOfDay.format(context);

    return Scaffold(
      backgroundColor: const Color(0xff27496d),
      //!APPBAR HAS TO BE DELETED - ONLY FOR TESTING
      appBar: AppBar(
        title: Text('Hello'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            setState(() {
              var item = {'text': 'New card', 'category': 'testing'};
              notificationData.insert(0, item);
              timeList.insert(0, res);
            });
          },
        ),
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: notificationData.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() {
                        notificationData.removeAt(index);
                        timeList.removeAt(index);
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
                        child: NotificationCard(
                            notificationData[index]['text'],
                            notificationData[index]['category'],
                            timeList[index]),
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
