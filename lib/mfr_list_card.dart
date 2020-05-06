import 'package:flutter/material.dart';
import 'package:ems_direct/mfr_profile.dart';

class MfrListCard extends StatefulWidget {
  String name;
  String contact;
  String rollNo;
  String gender;
  bool isSenior;
  var mfr;

  MfrListCard(var mfr) {
    this.mfr = mfr;
    this.name = mfr.name;
    this.rollNo = mfr.rollNo;
    this.isSenior = mfr.isSenior;
  }

  @override
  _MfrListCardState createState() => _MfrListCardState();
}

class _MfrListCardState extends State<MfrListCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 6,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MfrProfile(mfr: widget.mfr)));
        },
        child: ListTile(
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Icon(
                Icons.account_circle,
                size: 50,
                color: const Color(0xff27496d),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.name,
                        style: TextStyle(
                          letterSpacing: 1.0,
                          fontFamily: 'HelveticaNeueLight',
                          fontSize: 24,
                        )),
                    Text(widget.rollNo,
                        style: TextStyle(
                          letterSpacing: 1.0,
                          fontFamily: 'HelveticaNeueLight',
                        )),
                  ],
                ),
              ),
              widget.isSenior
                  ? Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blue[600],
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Text("S",
                                    style: TextStyle(
                                      fontFamily: "HelveticaNeueLight",
                                      fontSize: 15,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
