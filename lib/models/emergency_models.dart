import 'package:cloud_firestore/cloud_firestore.dart';

class SevereEmergencyModel {
  final String patientRollNo;
  final String genderPreference;
  final GeoPoint location;
  final int declines;
  final List declinedBy;
  final String severity;
  final String patientContactNo;
  final DateTime reportingTime;

  SevereEmergencyModel(
      {this.patientRollNo,
      this.genderPreference,
      this.location,
      this.declines,
      this.declinedBy,
      this.severity,
      this.patientContactNo,
      this.reportingTime});
}

class DeclinedEmergencyModel {
  final String patientRollNo;
  final String genderPreference;
  final GeoPoint location;
  final int declines;
  final List declinedBy;
  final String severity;
  final String patientContactNo;
  final DateTime reportingTime;

  DeclinedEmergencyModel(
      {this.patientContactNo,
      this.patientRollNo,
      this.genderPreference,
      this.location,
      this.declines,
      this.declinedBy,
      this.severity,
      this.reportingTime});
}

class PendingEmergencyModel {
  final String patientRollNo;
  final String genderPreference;
  final GeoPoint location;
  final int declines;
  final List declinedBy;
  final String severity;
  final DateTime reportingTime;
  final String patientContactNo;

  PendingEmergencyModel(
      {this.patientRollNo,
      this.genderPreference,
      this.location,
      this.declines,
      this.declinedBy,
      this.severity,
      this.patientContactNo,
      this.reportingTime});
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
  final String rollNo;

  AvailableMfrs(
      {this.contact,
      this.gender,
      this.isActive,
      this.isHostelite,
      this.isOccupied,
      this.isSenior,
      this.location,
      this.name,
      this.rollNo});
}

class OngoingEmergencyModel {
  final String patientRollNo;
  final String genderPreference;
  final GeoPoint location;
  final String mfr;
  final Map mfrDetails;
  final DateTime reportingTime;
  final String severity;
  final String patientContactNo;

  OngoingEmergencyModel(
      {this.patientRollNo,
      this.genderPreference,
      this.location,
      this.mfr,
      this.mfrDetails,
      this.reportingTime,
      this.severity,
      this.patientContactNo});
}

class EquipmentBagModel {
  final int bpApparatus;
  final int crepe;
  final int deepHeat;
  final int depressors;
  final int faceMasks;
  final int gauze;
  final int gloves;
  final int ORS;
  final int openWove;
  final int polyfax;
  final int polyfaxPlus;
  final int pyodine;
  final int saniplast;
  final int scissors;
  final int stethoscope;
  final int tape;
  final int thermometer;
  final int triangularBandage;
  final int wintogeno;
  EquipmentBagModel(
      {this.bpApparatus,
      this.crepe,
      this.deepHeat,
      this.depressors,
      this.faceMasks,
      this.gauze,
      this.gloves,
      this.ORS,
      this.openWove,
      this.polyfax,
      this.polyfaxPlus,
      this.pyodine,
      this.saniplast,
      this.scissors,
      this.stethoscope,
      this.tape,
      this.thermometer,
      this.triangularBandage,
      this.wintogeno});
}

class ReportedEmergencyModel {
  String patientRollNo; 
  String patientGender; 
  DateTime emergencyDate; 
  String primaryMfrRollNo; 
  String primaryMfrName; 
  String additionalMfrs; 
  String severity; 
  String patientIsHostelite;
  String emergencyType; 
  String emergencyLocation;
  String transportUsed;
  String emergencyDetails; 
  String bagUsed;
  Map equipmentUsed;

  ReportedEmergencyModel({
    this.patientRollNo, 
    this.patientGender, 
    this.emergencyDate, 
    this.primaryMfrRollNo, 
    this.primaryMfrName, 
    this.additionalMfrs, 
    this.severity, 
    this.patientIsHostelite,
    this.emergencyType, 
    this.emergencyLocation,
    this.transportUsed,
    this.emergencyDetails, 
    this.bagUsed,
    this.equipmentUsed,
  });

}