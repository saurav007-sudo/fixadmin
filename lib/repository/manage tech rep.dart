import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/manage tech ser.dart';

class ManageTechnicianRepository {
  final ManageTechnicianServices _services = ManageTechnicianServices();

  Stream<DocumentSnapshot> getTechnicianProfile(String docId) {
    return _services.getTechnicianProfileStream(docId);
  }

  Future<void> updateStatus(String docId, String status, bool isVerified, Map<String, dynamic> technicianData) async {
    await _services.updateStatusInFirestore(docId, status, isVerified, technicianData);
  }
}