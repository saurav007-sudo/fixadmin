import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/customer ser.dart';

class CustomersRepository {
  final CustomersServices _services = CustomersServices();

  Stream<QuerySnapshot> getUsersStream() {
    return _services.getUsersStream();
  }

  Stream<QuerySnapshot> getBookingsStream() {
    return _services.getBookingsStream();
  }

  Future<void> launchContactAction(BuildContext context, int index, String phoneNo, String email) async {
    Uri? url;

    if (index == 0) {
      url = Uri(
        scheme: "tel",
        path: phoneNo,
      );
    } else if (index == 1) {
      url = Uri(
        scheme: "sms",
        path: phoneNo,
      );
    } else if (index == 2) {
      url = Uri(
        scheme: "mailto",
        path: email.isNotEmpty ? email : "support@fixmate.com",
        queryParameters: {
          "subject": "Customer Support",
          "body": "Respected Sir/Madam,",
        },
      );
    }

    if (url != null && await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not launch action")),
      );
    }
  }
}