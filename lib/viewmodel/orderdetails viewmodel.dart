import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../repository/orderdetails rep.dart';

class OrderDetailsViewModel extends ChangeNotifier {
  final OrderDetailsRepository _repository = OrderDetailsRepository();

  Stream<DocumentSnapshot> getOrderDetailsStream(String orderId) {
    return _repository.getOrderDetails(orderId);
  }

  Future<void> makePhoneCall(BuildContext context, String phoneNumber) async {
    await _repository.makePhoneCall(context, phoneNumber);
    notifyListeners();
  }
}