class ServiceCategoriesModel {
  final String id;
  final String title;

  ServiceCategoriesModel({
    required this.id,
    required this.title,
  });

  factory ServiceCategoriesModel.fromMap(Map<String, dynamic> map, String docId) {
    return ServiceCategoriesModel(
      id: docId,
      title: map['title'] ?? 'Category',
    );
  }
}