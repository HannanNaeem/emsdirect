import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/models/emergency_models.dart';




class OpsDatabaseService {

  // collection references ops will be listening to

  final CollectionReference onGoingEmergencies = Firestore.instance.collection('OnGoingEmergencies');
  final CollectionReference pendingEmergencies = Firestore.instance.collection('PendingEmergencies');



  //Declined emergency list from snapshot
  List<DeclinedEmergencyModel> _pendingEmergencyListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return DeclinedEmergencyModel(
        patientRollNo : doc.data['patientRollNo'],
        genderPreference : doc.data['genderPreference'],
        location : doc.data['location'],
        declines : doc.data['declines'],
        declinedBy : doc.data['declinedBy'],
        severity : doc.data['severity'],
      );
    }).toList();
  }

  //Severe emergency list from snapshot
  List<SevereEmergencyModel> _severeEmergencyListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return SevereEmergencyModel(
        patientRollNo : doc.data['patientRollNo'],
        genderPreference : doc.data['genderPreference'],
        location : doc.data['location'],
        declines : doc.data['declines'],
        declinedBy : doc.data['declinedBy'],
        severity : doc.data['severity'],
      );
    }).toList();
  }

  //get pending emergencies
  Stream<List<DeclinedEmergencyModel>> get declinedStream {
    return pendingEmergencies.where('declines', isGreaterThanOrEqualTo: 4).snapshots().map(_pendingEmergencyListFromSnapshot);
  }

  //get severe emergencies
  Stream<List<SevereEmergencyModel>> get severeStream {
    return pendingEmergencies.where('severity', whereIn: ['high','critical']).snapshots().map(_severeEmergencyListFromSnapshot);
  }



}

