import 'package:flutter/material.dart';

import '../model/profile model.dart';
import '../repository/profile rep.dart';

class ProfileSettingsViewModel extends ChangeNotifier {
  final ProfileSettingsRepository _repository = ProfileSettingsRepository();

  late ProfileSettingsModel profileModel;

  ProfileSettingsViewModel() {
    profileModel = ProfileSettingsModel.initial();
  }

  Future<void> logout(BuildContext context) async {
    await _repository.logout(context);
    notifyListeners();
  }
}