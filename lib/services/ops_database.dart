import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/models/emergency_models.dart';




class OpsDatabaseService {

  // collection references ops will be listening to

  final CollectionReference onGoingEmergencies = Firestore.instance.collection('OnGoingEmergencies');
  final CollectionReference pendingEmergencies = Firestore.instance.collection('PendingEmergencies');



  //Pending emergency list from snapshot
  List<PendingEmergencyModel> _pendingEmergencyListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return PendingEmergencyModel(
        patientRollNo : doc.data['patientRollNo'],
        genderPreference : doc.data['genderPreference'],
        location : doc.data['location'],
        declines : doc.data['declines'],
        declinedBy : doc.data['declinedBy'],
      );
    }).toList();
  }

  //get pending emergencies
  Stream<List<PendingEmergencyModel>> get pendingStream {
    return pendingEmergencies.snapshots().map(_pendingEmergencyListFromSnapshot);
  }



}

