
import 'package:cloud_firestore/cloud_firestore.dart';

class SevereEmergencyModel {
  
  final String patientRollNo;
  final String genderPreference;
  final GeoPoint location;
  final int declines;
  final List declinedBy;
  final String severity;
  final String patientContactNo;

  SevereEmergencyModel({this.patientRollNo, this.genderPreference, this.location, this.declines, this.declinedBy, this.severity, this.patientContactNo});
}


class DeclinedEmergencyModel {
  
  final String patientRollNo;
  final String genderPreference;
  final GeoPoint location;
  final int declines;
  final List declinedBy;
  final String severity;
  final String patientContactNo;

  DeclinedEmergencyModel({this.patientContactNo,this.patientRollNo, this.genderPreference, this.location, this.declines, this.declinedBy, this.severity});
}


class PendingEmergencyModel {
  
  final String patientRollNo;
  final String genderPreference;
  final GeoPoint location;
  final int declines;
  final List declinedBy;
  final String severity;
  final String patientContactNo;

  PendingEmergencyModel({this.patientContactNo,this.patientRollNo, this.genderPreference, this.location, this.declines, this.declinedBy, this.severity});
}

class OngoingEmergencyModel {

  final String patientRollNo;
  final String genderPreference;
  final GeoPoint location;
  final String mfr;
  final DateTime reportingTime;
  final String severity;
  final String patientContactNo;

  OngoingEmergencyModel({this.patientContactNo,this.patientRollNo, this.genderPreference, this.location, this.mfr, this.reportingTime, this.severity});
}

class AvailableMfrs {

  final String contact;
  final String gender;
  final bool isActive;
  final bool isHostelite;
  final bool isOccupied;
  final bool isSenior;
  final GeoPoint location;
  final String name;

  AvailableMfrs({this.contact, this.gender, this.isActive, this.isHostelite, this.isOccupied, this.isSenior,this.location, this.name});
}

