import 'package:cloud_firestore/cloud_firestore.dart';

class PendingEmergencyModel {
  final String patientRollNo;
  final String genderPreference;
  final GeoPoint location;
  final int declines;
  final List declinedBy;
  final String severity;
  final String patientContactNo;

  PendingEmergencyModel(
      {this.patientRollNo,
      this.genderPreference,
      this.location,
      this.declines,
      this.declinedBy,
      this.severity,
      this.patientContactNo});
}

class OngoingEmergencyModel {
  final String patientRollNo;
  final String genderPreference;
  final GeoPoint location;
  final String mfr;
  final Timestamp reportingTime;
  final String severity;
  final String patientContactNo;

  OngoingEmergencyModel(
      {this.patientRollNo,
      this.genderPreference,
      this.location,
      this.mfr,
      this.reportingTime,
      this.severity,
      this.patientContactNo});
}
