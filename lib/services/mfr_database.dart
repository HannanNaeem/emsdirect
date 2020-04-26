import 'package:cloud_firestore/cloud_firestore.dart';

class MfrDatabaseService {
  // collection references ops will be listening to

  final CollectionReference onGoingEmergencies =
      Firestore.instance.collection('OnGoingEmergencies');
  final CollectionReference pendingEmergencies =
      Firestore.instance.collection('PendingEmergencies');

  //get pending emergencies
  Stream<QuerySnapshot> get pendingStream {
    return pendingEmergencies
        .where('severity', whereIn: ['low', 'medium']).snapshots();
  }
}
