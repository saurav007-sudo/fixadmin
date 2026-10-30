import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceCategoriesServices {
  Stream<QuerySnapshot> getCategoriesStream() {
    return FirebaseFirestore.instance
        .collection('service_categories')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> addCategoryToFirestore(String name) async {
    await FirebaseFirestore.instance.collection('service_categories').add({
      'title': name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteCategoryFromFirestore(String docId) async {
    await FirebaseFirestore.instance.collection('service_categories').doc(docId).delete();
  }
}