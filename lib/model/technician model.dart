class TechnicianModel {
  final String id;
  final String name;
  final String specialty;
  final String status;
  final String? profileImageUrl;

  TechnicianModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.status,
    this.profileImageUrl,
  });

  factory TechnicianModel.fromMap(Map<String, dynamic> map, String docId) {
    return TechnicianModel(
      id: docId,
      name: map['name'] ?? "Unknown Partner",
      specialty: map['selectedCategory'] ?? map['category'] ?? "General",
      status: map['verificationStatus'] ?? "Pending",
      profileImageUrl: map['profileImage'],
    );
  }
}