class ManageTechnicianModel {
  final String name;
  final String category;
  final String status;
  final String idType;
  final String idNumber;
  final String frontImg;
  final String backImg;
  final String yearsExp;
  final String qualification;
  final String workDesc;

  ManageTechnicianModel({
    required this.name,
    required this.category,
    required this.status,
    required this.idType,
    required this.idNumber,
    required this.frontImg,
    required this.backImg,
    required this.yearsExp,
    required this.qualification,
    required this.workDesc,
  });

  factory ManageTechnicianModel.fromMap(Map<String, dynamic>? map) {
    var data = map ?? {};
    return ManageTechnicianModel(
      name: data['name'] ?? "Suresh Babu",
      category: data['selectedCategory'] ?? data['serviceName'] ?? data['category'] ?? "Electrician",
      status: data['verificationStatus'] ?? "Pending",
      idType: data['idType'] ?? "Government ID",
      idNumber: data['idNumber'] ??
          data['id_number'] ??
          data['documentNumber'] ??
          data['number'] ??
          data['idNo'] ??
          data['id'] ??
          data['govId'] ??
          "Not Provided",
      frontImg: data['idFrontUrl'] ?? "",
      backImg: data['idBackUrl'] ?? "",
      yearsExp: data['yearsOfExperience'] ?? data['experience'] ?? "3 Years",
      qualification: data['qualification'] ?? data['degree'] ?? "ITI Electrical Diploma",
      workDesc: data['workDescription'] ??
          data['description'] ??
          data['bio'] ??
          data['details'] ??
          "No description provided.",
    );
  }
}