import 'package:cloud_firestore/cloud_firestore.dart';

class TechniciansServices {
  Stream<QuerySnapshot> getPartnersStream() {
    return FirebaseFirestore.instance.collection('partners').snapshots();
  }
}