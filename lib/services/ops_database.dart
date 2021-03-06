import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/models/emergency_models.dart';

class OpsDatabaseService {
  // collection references ops will be listening to

  final CollectionReference onGoingEmergencies =
      Firestore.instance.collection('OngoingEmergencies');
  
  final CollectionReference pendingEmergencies =
      Firestore.instance.collection('PendingEmergencies');
  
  final CollectionReference availableMfrs =
      Firestore.instance.collection('Mfr');
  
  final CollectionReference equipmentBags = 
      Firestore.instance.collection('EquipmentBags');


  //Declined emergency list from snapshot
  List<DeclinedEmergencyModel> _declinedEmergencyListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return DeclinedEmergencyModel(
        patientRollNo: doc.data['patientRollNo'],
        genderPreference: doc.data['genderPreference'],
        location: doc.data['location'] ?? null,
        declines: doc.data['declines'],
        declinedBy: doc.data['declinedBy'],
        severity: doc.data['severity'],
        patientContactNo: doc.data['patientContactNo'] ?? '',
        reportingTime : doc.data['reportingTime'].toDate() ?? null,
      );
    }).toList();
  }

  //Declined emergency list from snapshot
  List<PendingEmergencyModel> _pendingEmergencyListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return PendingEmergencyModel(
        patientRollNo: doc.data['patientRollNo'],
        genderPreference: doc.data['genderPreference'],
        location: doc.data['location'] ?? null,
        declines: doc.data['declines'],
        declinedBy: doc.data['declinedBy'],
        severity: doc.data['severity'],
        patientContactNo: doc.data['patientContactNo'] ?? '',
        reportingTime : doc.data['reportingTime'].toDate() ?? null,
      );
    }).toList();
  }

  //Severe emergency list from snapshot
  List<SevereEmergencyModel> _severeEmergencyListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return SevereEmergencyModel(
        patientRollNo: doc.data['patientRollNo'],
        genderPreference: doc.data['genderPreference'],
        location: doc.data['location'] ?? null ,
        declines: doc.data['declines'],
        declinedBy: doc.data['declinedBy'],
        severity: doc.data['severity'],
        patientContactNo: doc.data['patientContactNo'] ?? '',
        reportingTime : doc.data['reportingTime'].toDate() ?? null,
      );
    }).toList();
  }

  //Ongoingemergency list from snapshot
  List<OngoingEmergencyModel> _onGoingEmergencyListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return OngoingEmergencyModel(
        patientRollNo: doc.data['patientRollNo'],
        genderPreference: doc.data['genderPreference'],
        location: doc.data['location'],
        severity: doc.data['severity'],
        patientContactNo: doc.data['patientContactNo'] ?? '',
        mfr: doc.data['mfr'],
        mfrDetails: doc.data['mfrDetails'],
        reportingTime: doc.data['reportingTime'].toDate() ?? null,
      );
    }).toList();
  }

  //Mfr List from snapshot
  List<MfrListModel> mfrListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return MfrListModel(
        name: doc.data['name'],
        rollNo: doc.documentID,
        gender: doc.data['gender'],
        contact: doc.data['contact'],
        isHostelite: doc.data['isHostelite'],
        isSenior: doc.data['isSenior'],
      );
    }).toList();
  }

  //Declined emergency list from snapshot
  List<AvailableMfrs> _availableMfrsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return AvailableMfrs(
        contact: doc.data['contact'],
        gender: doc.data['gender'],
        isActive: doc.data['isActive'],
        isHostelite: doc.data['isHostelite'],
        isOccupied: doc.data['isOccupied'],
        isSenior: doc.data['isSenior'],
        location: doc.data['location'],
        name: doc.data['name'],
        rollNo: doc.documentID,
      );
    }).toList();
  }

  // Equipment bag list from snapshot
  List<EquipmentBagModel> equipmentBagListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return EquipmentBagModel(
          items: doc.data,
          name: doc.documentID,
      );
    }).toList();
  }

  //equipment bag stream
  Stream<List<EquipmentBagModel>> get equipmentBagsStream {
    return equipmentBags.snapshots().map(equipmentBagListFromSnapshot);
  }

  //get pending emergencies
  Stream<List<DeclinedEmergencyModel>> get declinedStream {
    return pendingEmergencies.where('declines', isGreaterThanOrEqualTo: 4).snapshots().map(_declinedEmergencyListFromSnapshot);
  }

  //get severe emergencies
  Stream<List<SevereEmergencyModel>> get severeStream {
    return pendingEmergencies.where('severity', whereIn: ['high','critical']).snapshots().map(_severeEmergencyListFromSnapshot);
  }

  //get pending emergencies
  Stream<List<PendingEmergencyModel>> get pendingStream {
    return pendingEmergencies
        .snapshots()
        .map(_pendingEmergencyListFromSnapshot);
  }

  //get onGoing emergencies
  Stream<List<OngoingEmergencyModel>> get onGoingStream {
     return onGoingEmergencies.orderBy('reportingTime').snapshots().map(_onGoingEmergencyListFromSnapshot);  
  }

  //get available mfrs
  Stream<List<AvailableMfrs>> get availableMfrStream {
    return availableMfrs
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(_availableMfrsListFromSnapshot);
  }

  Stream<List<AvailableMfrs>> get availableMfrStream2 {
    return availableMfrs
        .where('isActive', isEqualTo: true)
        .where('isOccupied', isEqualTo: false)
        .snapshots()
        .map(_availableMfrsListFromSnapshot);
  }
  // streams needed for student
  Stream<List<PendingEmergencyModel>> studentPendingStream(String rollNo){
    return pendingEmergencies.where('patientRollNo', isEqualTo: rollNo).snapshots().map(_pendingEmergencyListFromSnapshot);
  }

  Stream<List<OngoingEmergencyModel>> studentOnGoingStream(String rollNo){
    return onGoingEmergencies.where('patientRollNo', isEqualTo: rollNo).snapshots().map(_onGoingEmergencyListFromSnapshot);
  }

}
