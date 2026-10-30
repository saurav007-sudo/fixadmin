class ProfileSettingsModel {
  final List<String> names;

  ProfileSettingsModel({
    required this.names,
  });

  factory ProfileSettingsModel.initial() {
    return ProfileSettingsModel(
      names: [
        "Suresh",
        "To be more secure",
      ],
    );
  }
}