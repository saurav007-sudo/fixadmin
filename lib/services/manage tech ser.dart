import 'package:cloud_firestore/cloud_firestore.dart';

class ManageTechnicianServices {
  Stream<DocumentSnapshot> getTechnicianProfileStream(String docId) {
    return FirebaseFirestore.instance.collection('partners').doc(docId).snapshots();
  }

  Future<void> updateStatusInFirestore(String docId, String status, bool isVerified, Map<String, dynamic> technicianData) async {
    await FirebaseFirestore.instance.collection('partners').doc(docId).set({
      'verificationStatus': status,
      'isVerified': isVerified,
    }, SetOptions(merge: true));

    if (status == "Approved") {
      String category = technicianData['selectedCategory'] ??
          technicianData['serviceName'] ??
          technicianData['category'] ??
          "AC Service";

      await FirebaseFirestore.instance.collection(category).doc(docId).set({
        ...technicianData,
        'verificationStatus': status,
        'isVerified': isVerified,
        'approvedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }
}