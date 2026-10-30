import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/technician ser.dart';

class TechniciansRepository {
  final TechniciansServices _services = TechniciansServices();

  Stream<QuerySnapshot> getPartners() {
    return _services.getPartnersStream();
  }
}