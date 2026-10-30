import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHomeServices {
  Stream<QuerySnapshot> getBookingsStream() {
    return FirebaseFirestore.instance.collection('bookings').snapshots();
  }

  Stream<QuerySnapshot> getPartnersStream() {
    return FirebaseFirestore.instance.collection('partners').snapshots();
  }

  Stream<QuerySnapshot> getOrderedBookingsStream() {
    return FirebaseFirestore.instance
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}