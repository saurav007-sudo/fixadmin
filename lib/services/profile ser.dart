import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixadmin/view/login.dart';
import 'package:flutter/material.dart';

class ProfileSettingsServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signOutUser(BuildContext context) async {
    try {
      await _auth.signOut();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Logged out successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
            (route) => false,
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Logout failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}