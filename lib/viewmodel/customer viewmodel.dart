import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

import '../repository/customer rep.dart';

class CustomersViewModel extends ChangeNotifier {
  final CustomersRepository _repository = CustomersRepository();

  final TextEditingController searchController = TextEditingController();
  List<dynamic> availableCustomers = [];
  List<dynamic> filteredCustomers = [];

  void filterCustomers(String query) {
    filteredCustomers = availableCustomers.where((doc) {
      var data = doc.data() as Map<String, dynamic>;
      String name = (data['name'] ?? "").toLowerCase();
      String phone = (data['phoneno'] ?? data['phone'] ?? "").toLowerCase();
      String q = query.toLowerCase().trim();
      return name.contains(q) || phone.contains(q);
    }).toList();
    notifyListeners();
  }

  void updateCustomers(List<dynamic> docs) {
    availableCustomers = docs;
    if (searchController.text.isEmpty) {
      filteredCustomers = docs;
    }
  }

  Stream<QuerySnapshot> getUsersStream() {
    return _repository.getUsersStream();
  }

  Stream<QuerySnapshot> getBookingsStream() {
    return _repository.getBookingsStream();
  }

  // Handle phone call launching via url_launcher
  Future<void> handleContactAction(BuildContext context, int index, String phoneNo, String email) async {
    if (phoneNo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone number not available")),
      );
      return;
    }

    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNo);

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not open dialpad")),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error launching dialpad: $e")),
        );
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}