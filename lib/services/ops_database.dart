import 'package:cloud_firestore/cloud_firestore.dart';


class OpsDatabaseService {

  // collection references ops will be listening to

  final CollectionReference onGoingEmergencies = Firestore.instance.collection('OnGoingEmergencies');
  final CollectionReference pendingEmergencies = Firestore.instance.collection('PendingEmergencies');


  //get pending emergencies
  Stream<QuerySnapshot> get pendingStream {
    return pendingEmergencies.where('declines',isEqualTo: 4).snapshots();
  }

  //get severe emergencies
  // Stream<QuerySnapshot> get severeStream {
  //   return pendingEmergencies.where('severity',isEqualTo: );
  // }


}