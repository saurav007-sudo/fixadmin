import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/service ser.dart';

class ServiceCategoriesRepository {
  final ServiceCategoriesServices _services = ServiceCategoriesServices();

  Stream<QuerySnapshot> getCategories() {
    return _services.getCategoriesStream();
  }

  Future<void> addCategory(BuildContext context, String name) async {
    await _services.addCategoryToFirestore(name);
  }

  Future<void> deleteCategory(String docId) async {
    await _services.deleteCategoryFromFirestore(docId);
  }
}