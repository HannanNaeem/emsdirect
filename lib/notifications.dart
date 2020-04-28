
import 'package:ems_direct/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/notification_data.dart';
import 'package:ems_direct/models/emergency_models.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NotificationItem {
  String category;
  dynamic item;

  NotificationItem({this.category, this.item});
}


class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  var notificationData = NotificationData.data;
  var hello = NotificationData.hello;
  var timeList = NotificationData.timeList;


 List<NotificationItem> _listToNotificationData(List<dynamic> itemList,String category) {
    return itemList.map((item) {
      print(item);
      return NotificationItem(
        
        item : item,
        category: category,
      );
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    //providers
    var _declinedEmergenciesList = Provider.of<List<DeclinedEmergencyModel>>(context);
    var _severeEmergenciesList = Provider.of<List<SevereEmergencyModel>>(context);

    // to add later equipment
    List<NotificationItem> _notificationList = [];
    //Daisy chain to build notifications
    int divider1 = 0;
    if(_declinedEmergenciesList != null)
    {
      _notificationList = _listToNotificationData(_severeEmergenciesList, "Severe Emergency!");
      divider1++;
    }
    if(_severeEmergenciesList != null)
    {
       _notificationList.addAll(_listToNotificationData(_declinedEmergenciesList, "Ignored Emergency!"));
    }


    String _getDividerText(String category)
    {
      if(category == 'Ignored Emergency!')
        return 'Ignored Emergencies';
      else if (category == 'Severe Emergency!')
        return 'Severe Emergencies';
      else
        return '';
    }

    String _getNotificationText(var item, String category)
    {
      if(category == 'Ignored Emergency!')
      {
        return "An emergency has been ignored! Please manually assign a MFR via Map\n\n Patient Details:\n  ${item.patientRollNo}\n  ${item.patientContactNo}";
      }
      else
        return "A severe emergency has been initiated! Please manually assign a MFR via Map\n Severity: ${item.severity}\n\n Patient Details:\n  ${item.patientRollNo}\n  ${item.patientContactNo}";
    }


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
                itemCount: _notificationList.length,
                itemBuilder: (context, index) {


                  if(index == divider1 || index == 0) 
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,12,0,12),
                        child: Row(children: <Widget>[
                              Expanded(child: Divider(color: const Color(0xff00a8cc))),       
                              Padding(
                                padding: const EdgeInsets.fromLTRB(7,0,7,0),
                                child: Text(_getDividerText(_notificationList[index].category), 
                                  style: TextStyle(
                                    color: const Color(0xff00a8cc),
                                    fontFamily: 'HelveticaNeueLight'
                                  )),
                              ),        
                              Expanded(child: Divider(color : const Color(0xff00a8cc))),]
                    ),
                      ),
                    Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 100,
                      ),
                      child: NotificationCard(
                          _getNotificationText(_notificationList[index].item, _notificationList[index].category),
                          _notificationList[index].category,
                          DateFormat.jm().format(_notificationList[index].item.reportingTime)),
                    ),
                  ),

                    ],
                  ); 
                  else
                  return Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 100,
                      ),
                      child: NotificationCard(
                          _getNotificationText(_notificationList[index].item, _notificationList[index].category),
                          _notificationList[index].category,
                          DateFormat.jm().format(_notificationList[index].item.reportingTime)),
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
