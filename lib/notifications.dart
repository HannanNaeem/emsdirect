
import 'package:ems_direct/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/models/emergency_models.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NotificationItem {
  String category;
  dynamic item;
  Widget divider;

  NotificationItem({this.category, this.item, this.divider});
}


class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {


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
    var _equipmentBagsList = Provider.of<List<EquipmentBagModel>>(context);

    //------ Process bags first -----------//
    List<EquipmentBagModel> _markedBagsList = [];

    if(_equipmentBagsList != null){
      //check each bag
      _equipmentBagsList.forEach((bag){
        //for each bag fo through items = keys
        bag.items.keys.forEach((item){
          //check if count is < 1 if yes add to marked list
          if(!_markedBagsList.contains(bag) && (bag.items[item] == null || bag.items[item] < 1)){
            //add to marked - This bag need restock
            _markedBagsList.add(bag);    
          }
        });
      });
    }

    // to add later equipment
    List<NotificationItem> _notificationList = [];
    //Daisy chain to build notifications

    if(_severeEmergenciesList != null && _severeEmergenciesList.length!= 0)
    {
      //! Add divider first
      _notificationList.add(
        NotificationItem(category: "divider", 
        divider: Padding(
            padding: const EdgeInsets.fromLTRB(0,12,0,12),
            child: Row(children: <Widget>[
                  Expanded(child: Divider(color: Colors.grey[400])),       
                  
                  Padding(
                    padding: const EdgeInsets.fromLTRB(7,0,7,0),
                    child: Text("Severe Emergencies", 
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontFamily: 'HelveticaNeueLight'
                      )
                  ),
                  ),        
                  
                  Expanded(child: Divider(color :  Colors.grey[400])),]
            ),
          ),
        ));

        //! add items
      _notificationList.addAll(_listToNotificationData(_severeEmergenciesList, "Severe Emergency!"));
    }
    if(_declinedEmergenciesList!= null && _declinedEmergenciesList.length != 0)
    {
      //! Add divider first
      _notificationList.add(
        NotificationItem(category: "divider", 
        divider: Padding(
            padding: const EdgeInsets.fromLTRB(0,12,0,12),
            child: Row(children: <Widget>[
                  Expanded(child: Divider(color: Colors.grey[400])),       
                  
                  Padding(
                    padding: const EdgeInsets.fromLTRB(7,0,7,0),
                    child: Text("Ignored Emergencies", 
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontFamily: 'HelveticaNeueLight'
                      )
                  ),
                  ),        
                  
                  Expanded(child: Divider(color: Colors.grey[400])),]
            ),
          ),
        ));

       _notificationList.addAll(_listToNotificationData(_declinedEmergenciesList, "Ignored Emergency!"));
    }
    if(_markedBagsList.length != 0){

      //! Add divider first
      _notificationList.add(
        NotificationItem(category: "divider", 
        divider: Padding(
            padding: const EdgeInsets.fromLTRB(0,12,0,12),
            child: Row(children: <Widget>[
                  Expanded(child: Divider(color: Colors.grey[400])),       
                  
                  Padding(
                    padding: const EdgeInsets.fromLTRB(7,0,7,0),
                    child: Text("Equipment Alerts", 
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontFamily: 'HelveticaNeueLight'
                      )
                  ),
                  ),                     
                  Expanded(child: Divider(color : Colors.grey[400])),]
            ),
          ),
        ));

      _notificationList.addAll(_listToNotificationData(_markedBagsList, "Restock Needed!"));
    }



    String _getNotificationText(var item, String category)
    {
      if(category == 'Ignored Emergency!')
      {
        return "An emergency has been ignored! Please manually assign a MFR via Map";
      }
      else if (category == 'Severe Emergency!'){
        return "A severe emergency has been initiated! Please manually assign a MFR via Map";
      }
      else if (category == 'Restock Needed!'){
        return "${item.name} Bag needs restock! Please check bag contents from Records";
      }
    
    }

  

    return Scaffold(
      backgroundColor: const Color(0xff27496d),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            
            Expanded(
              child: ListView.builder(
                itemCount: _notificationList == null ? 0 : _notificationList.length,
                itemBuilder: (context, index) {
                  
                  //determine to return divider or card
                  if(_notificationList[index].category == "divider")
                    return(_notificationList[index].divider);
                  else
                    return Column(
                    children: <Widget>[
                    Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 100,
                      ),
                      child: NotificationCard(
                          //!text
                          _getNotificationText(_notificationList[index].item, _notificationList[index].category),
                          //!category
                          _notificationList[index].category,
                          //!Time
                          _notificationList[index].category == "Restock Needed!" ?
                          DateFormat.jm().format(DateTime.now()) // for restock return the current time
                          : DateFormat.jm().format(_notificationList[index].item.reportingTime),
                          _notificationList[index].category != "Restock Needed!" ?  //for emergencies pass severity
                          _notificationList[index].item.severity
                          : "None",
                          _notificationList[index].category != "Restock Needed!" ?  //for emergencies pass severity
                          "Patient Details:" + "\n" +_notificationList[index].item.patientRollNo + "\n" +_notificationList[index].item.patientContactNo
                          : "None",
                      ),

                    ),
                  ),

                    ],
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
