import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'customer view.dart';
import 'home view.dart';
import 'profile view.dart';
import 'service view.dart';
import 'technician view.dart';


class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int select = 0;

  List page = [
  Home(),
   ServiceCategoriesPage(),
    Technicians(),
    CustomersPage(),
    Profile()

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: select,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            select = index;
          });
        },
        items:  [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Services",
            icon: Icon(Icons.home_repair_service),
            activeIcon: Icon(Icons.cleaning_services),
          ),
          BottomNavigationBarItem(
            label: "Technicians",
            icon: Icon(Icons.badge_outlined),
            activeIcon: Icon(Icons.badge),
          ),
          BottomNavigationBarItem(
            label: "Customers",
            icon: Icon(Icons.group_outlined),
            activeIcon: Icon(Icons.group),
          ),
          BottomNavigationBarItem(
            label: "Settings",
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
          ),
        ],
      ),
      body: page[select],
    );
  }
}