import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../repository/manage tech rep.dart';

class ManageTechnicianViewModel extends ChangeNotifier {
  final ManageTechnicianRepository _repository = ManageTechnicianRepository();
  bool isLoading = false;

  Stream<DocumentSnapshot> getTechnicianStream(String docId) {
    return _repository.getTechnicianProfile(docId);
  }

  Future<void> updateVerificationStatus(
      BuildContext context,
      String? partnerId,
      String status,
      bool isVerified,
      Map<String, dynamic> technicianData,
      ) async {
    String docId = partnerId ?? 'sample_partner';
    isLoading = true;
    notifyListeners();

    try {
      await _repository.updateStatus(docId, status, isVerified, technicianData);

      isLoading = false;
      notifyListeners();

      if (!context.mounted) return;

      // Dynamic message based on verification state
      String message = isVerified ? "Profile approved" : "Profile rejected";
      Color bgColor = isVerified ? Colors.green : Colors.red;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: bgColor,
        ),
      );
    } catch (e) {
      isLoading = false;
      notifyListeners();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update status: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}