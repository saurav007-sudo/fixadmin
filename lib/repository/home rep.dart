import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/home ser.dart';

class AdminHomeRepository {
  final AdminHomeServices _services = AdminHomeServices();

  Stream<QuerySnapshot> getBookings() {
    return _services.getBookingsStream();
  }

  Stream<QuerySnapshot> getPartners() {
    return _services.getPartnersStream();
  }

  Stream<QuerySnapshot> getOrderedBookings() {
    return _services.getOrderedBookingsStream();
  }
}