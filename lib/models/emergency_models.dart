
import 'package:cloud_firestore/cloud_firestore.dart';

class PendingEmergencyModel {
  
  final String patientRollNo;
  final String genderPreference;
  final GeoPoint location;
  final int declines;
  final List declinedBy;

  PendingEmergencyModel({this.patientRollNo, this.genderPreference, this.location, this.declines, this.declinedBy});
}