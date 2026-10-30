import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsServices {
  Stream<DocumentSnapshot> getOrderDetailsStream(String orderId) {
    return FirebaseFirestore.instance
        .collection('bookings')
        .doc(orderId)
        .snapshots();
  }

  Future<void> launchPhoneCall(BuildContext context, String phoneNumber) async {
    Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not launch phone dialer")),
      );
    }
  }
}