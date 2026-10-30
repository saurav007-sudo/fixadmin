class OrderDetailsModel {
  final String bookingId;
  final String serviceName;
  final String technicianName;
  final String customerName;
  final String customerPhone;
  final String category;
  final String scheduledDate;
  final String location;
  final String status;
  final double basePrice;
  final double serviceFee;
  final double platformFee;
  final double totalAmount;

  OrderDetailsModel({
    required this.bookingId,
    required this.serviceName,
    required this.technicianName,
    required this.customerName,
    required this.customerPhone,
    required this.category,
    required this.scheduledDate,
    required this.location,
    required this.status,
    required this.basePrice,
    required this.serviceFee,
    required this.platformFee,
    required this.totalAmount,
  });

  factory OrderDetailsModel.fromMap(Map<String, dynamic> map, String docId) {
    String bookingId = map['bookingId'] ?? '#${docId.substring(0, 5).toUpperCase()}';
    String serviceName = map['serviceName'] ?? 'Service';
    String technicianName = map['name'] ?? 'Technician';
    String customerName = map['customerName'] ?? 'Customer Name';
    String customerPhone = map['customerPhone'] ?? '+91 98765 43210';
    String category = map['serviceName'] ?? 'General Service';
    String scheduledDate = map['date'] != null && map['time'] != null
        ? "${map['date']}\n${map['time']}"
        : "Today, 4:00 PM";
    String location = map['location'] ?? 'Kadavanthra, Kochi';
    String status = map['status']?.toString().toLowerCase() ?? 'pending';

    double basePrice = double.tryParse(map['basePrice']?.toString() ?? '299') ?? 299.0;
    double serviceFee = basePrice * 0.05;
    double platformFee = 25.0;
    double totalAmount = basePrice + serviceFee + platformFee;

    return OrderDetailsModel(
      bookingId: bookingId,
      serviceName: serviceName,
      technicianName: technicianName,
      customerName: customerName,
      customerPhone: customerPhone,
      category: category,
      scheduledDate: scheduledDate,
      location: location,
      status: status,
      basePrice: basePrice,
      serviceFee: serviceFee,
      platformFee: platformFee,
      totalAmount: totalAmount,
    );
  }
}