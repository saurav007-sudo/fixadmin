import 'package:flutter/material.dart';

import '../services/profile ser.dart';

class ProfileSettingsRepository {
  final ProfileSettingsServices _services = ProfileSettingsServices();

  Future<void> logout(BuildContext context) async {
    await _services.signOutUser(context);
  }
}