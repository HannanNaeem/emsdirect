import 'package:ems_direct/log_card.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/log_data.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EmergencyLog extends StatefulWidget {
  @override
  _LogState createState() => _LogState();
}

class _LogState extends State<EmergencyLog> {
  var logData = LogData.data;
  // var hello = NotificationData.hello;
  var timeList = LogData.timeList;

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
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: logData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 100,
                      ),
                      child: LogCard(
                          logData[index]['name'],
                          logData[index]['number'],
                          logData[index]['gender'],
                          logData[index]['severity'],
                          timeList[index]),
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
