import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/orderdetails ser.dart';

class OrderDetailsRepository {
  final OrderDetailsServices _services = OrderDetailsServices();

  Stream<DocumentSnapshot> getOrderDetails(String orderId) {
    return _services.getOrderDetailsStream(orderId);
  }

  Future<void> makePhoneCall(BuildContext context, String phoneNumber) async {
    await _services.launchPhoneCall(context, phoneNumber);
  }
}