import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//---------------------------------------------------------------------------
// Below is the widget tree for the card that is displayed on the emergency numbers
// screen. 
//----------------------------------------------------------------------------


class EmergencyNumberCard extends StatefulWidget {
  String name;
  String contact;


  EmergencyNumberCard(String name, String contact) {
    this.name = name;
    this.contact = contact;
  }

  @override
  _EmergencyNumberCardState createState() => _EmergencyNumberCardState();
}

class _EmergencyNumberCardState extends State<EmergencyNumberCard> {

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: ListTile(
          title: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.name,
                    style: TextStyle(
                      letterSpacing: 1.0,
                      fontFamily: 'HelveticaNeueLight',
                      color: Color(0xff142850),
                      fontSize: 22,
                    )
                  ),
                  Text(
                    widget.contact,
                    style: TextStyle(
                      letterSpacing: 3.0,
                      fontFamily: 'HelveticaNeueLight',
                      fontSize: 18,
                    )
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.call,
                        size: 30,
                        color: Colors.green,
                      ),
                      
                      // On pressing the phone icon try calling the number
                      onPressed: () async {
                        if(await canLaunch("tel:${widget.contact}"))
                        {
                          await launch("tel:${widget.contact}");
                        }
                        else
                          print("could not launch");
                      },
                    ),

                 ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

