import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../repository/home rep.dart';

class AdminHomeViewModel extends ChangeNotifier {
  final AdminHomeRepository _repository = AdminHomeRepository();

  Stream<QuerySnapshot> getBookingsStream() {
    return _repository.getBookings();
  }

  Stream<QuerySnapshot> getPartnersStream() {
    return _repository.getPartners();
  }

  Stream<QuerySnapshot> getOrderedBookingsStream() {
    return _repository.getOrderedBookings();
  }
}