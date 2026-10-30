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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Technician profile marked as $status")),
      );
    } catch (e) {
      isLoading = false;
      notifyListeners();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating status: $e")),
      );
    }
  }
}