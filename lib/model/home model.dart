class OrderModel {
  final String id;
  final String bookingId;
  final String serviceName;
  final String status;

  OrderModel({
    required this.id,
    required this.bookingId,
    required this.serviceName,
    required this.status,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String docId) {
    return OrderModel(
      id: docId,
      bookingId: map['bookingId'] ?? '#${docId.substring(0, 5).toUpperCase()}',
      serviceName: map['serviceName'] ?? map['category'] ?? 'Service',
      status: map['status']?.toString().toLowerCase() ?? 'pending',
    );
  }
}