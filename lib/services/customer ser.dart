import 'package:cloud_firestore/cloud_firestore.dart';

class CustomersServices {
  Stream<QuerySnapshot> getUsersStream() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  Stream<QuerySnapshot> getBookingsStream() {
    return FirebaseFirestore.instance.collection('bookings').snapshots();
  }
}