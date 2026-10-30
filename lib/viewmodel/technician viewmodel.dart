import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../repository/technician rep.dart';

class TechniciansViewModel extends ChangeNotifier {
  final TechniciansRepository _repository = TechniciansRepository();

  final TextEditingController searchController = TextEditingController();
  List<dynamic> availableTechnicians = [];
  List<dynamic> filteredTechnicians = [];

  Stream<QuerySnapshot> getPartnersStream() {
    return _repository.getPartners();
  }

  void filterTechnicians(String query) {
    filteredTechnicians = availableTechnicians.where((doc) {
      var data = doc.data() as Map<String, dynamic>;
      String name = (data['name'] ?? data['ProductName'] ?? "").toLowerCase();
      return name.contains(query.toLowerCase().trim());
    }).toList();
    notifyListeners();
  }

  void updateTechnicians(List<dynamic> docs) {
    availableTechnicians = docs;
    if (searchController.text.isEmpty) {
      filteredTechnicians = docs;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}