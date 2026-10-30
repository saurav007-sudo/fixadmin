class CustomerModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? profileImageUrl;

  CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.profileImageUrl,
  });

  factory CustomerModel.fromMap(Map<String, dynamic> map, String docId) {
    return CustomerModel(
      id: docId,
      name: map['name'] ?? 'Customer',
      phone: map['phoneno'] ?? map['phone'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImage'] ?? map['imageUrl'],
    );
  }
}