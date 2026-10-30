import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../repository/service rep.dart';

class ServiceCategoriesViewModel extends ChangeNotifier {
  final ServiceCategoriesRepository _repository = ServiceCategoriesRepository();
  final TextEditingController categoryNameController = TextEditingController();

  Stream<QuerySnapshot> getCategoriesStream() {
    return _repository.getCategories();
  }

  Future<void> addCategory(BuildContext context) async {
    String name = categoryNameController.text.trim();

    if (name.isNotEmpty) {
      await _repository.addCategory(context, name);
      categoryNameController.clear();
      notifyListeners();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Category added successfully!")),
      );
    }
  }

  Future<void> deleteCategory(String docId) async {
    await _repository.deleteCategory(docId);
    notifyListeners();
  }

  @override
  void dispose() {
    categoryNameController.dispose();
    super.dispose();
  }
}