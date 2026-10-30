import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/profile viewmodel.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileSettingsViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Color(0xFFEFF9FF),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Row(
              children: [
                Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15, left: 15, bottom: 8),
            child: Text(
              "Account Settings",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black54,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8, bottom: 80),
            child: GestureDetector(
              onTap: () {
                profileViewModel.logout(context);
              },
              child: Container(
                height: 58,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.red[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 22.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        size: 40,
                        color: Colors.red,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 24),
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}