import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/models/emergency_models.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';

class MfrDatabaseService {
  // collection references mfr will be listening to
  final CollectionReference onGoingEmergencies =
      Firestore.instance.collection('OngoingEmergencies');
  final CollectionReference pendingEmergencies =
      Firestore.instance.collection('PendingEmergencies');

  //Pending emergency list from snapshot
  List<PendingEmergencyModel> _pendingEmergencyListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return PendingEmergencyModel(
        patientRollNo: doc.data['patientRollNo'],
        genderPreference: doc.data['genderPreference'],
        location: doc.data['location'],
        declines: doc.data['declines'],
        declinedBy: doc.data['declinedBy'],
        severity: doc.data['severity'],
      );
    }).toList();
  }

  //Ongoing emergency list from snapshot
  List<OngoingEmergencyModel> _ongoingEmergencyListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return OngoingEmergencyModel(
        patientRollNo: doc.data['patientRollNo'],
        genderPreference: doc.data['genderPreference'],
        location: doc.data['location'],
        mfr: doc.data['mfr'],
        reportingTime: doc.data['reportingTime'].toDate(),
        severity: doc.data['severity'],
        patientContactNo: doc.data['patientContactNo'],
      );
    }).toList();
  }

  //get pending emergencies
  Stream<List<PendingEmergencyModel>> get pendingStream {
    return pendingEmergencies
        .where('severity', whereIn: ['low', 'medium'])
        .snapshots()
        .map(_pendingEmergencyListFromSnapshot);
  }

  //get ongoing emergencies
  Stream<List<OngoingEmergencyModel>> get ongoingStream {
    return onGoingEmergencies
        .snapshots()
        .map(_ongoingEmergencyListFromSnapshot);
  }
}
