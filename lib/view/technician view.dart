import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/technician model.dart';
import '../view/manage tech view.dart';
import '../viewmodel/technician viewmodel.dart';

class Technicians extends StatelessWidget {
  const Technicians({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TechniciansViewModel>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Color(0xFFE8EEF6),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Technicians",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A2A42),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: provider.searchController,
                              onChanged: (value) {
                                provider.filterTechnicians(value);
                              },
                              decoration: InputDecoration(
                                hintText: "Search technicians...",
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                                prefixIcon: Icon(CupertinoIcons.search, color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  StreamBuilder<QuerySnapshot>(
                    stream: provider.getPartnersStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('Error :: ${snapshot.error}'),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (snapshot.hasData) {
                        provider.updateTechnicians(snapshot.data!.docs);

                        if (provider.filteredTechnicians.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.all(30.0),
                            child: Center(
                              child: Text(
                                "No technicians found.",
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: provider.filteredTechnicians.length,
                          itemBuilder: (context, index) {
                            var snap = provider.filteredTechnicians[index];
                            var partnerData = snap.data() as Map<String, dynamic>;
                            TechnicianModel technician = TechnicianModel.fromMap(partnerData, snap.id);

                            ImageProvider avatarBackgroundImage;
                            if (technician.profileImageUrl != null && technician.profileImageUrl!.startsWith('http')) {
                              avatarBackgroundImage = NetworkImage(technician.profileImageUrl!);
                            } else {
                              avatarBackgroundImage = AssetImage("lib/image/profile3.jpg");
                            }

                            Color statusBgColor;
                            Color statusTextColor;

                            if (technician.status == "Approved" || technician.status == "Active") {
                              statusBgColor = Colors.green.shade100;
                              statusTextColor = Colors.green.shade800;
                            } else if (technician.status == "Pending") {
                              statusBgColor = Colors.orange.shade100;
                              statusTextColor = Colors.orange.shade800;
                            } else {
                              statusBgColor = Colors.grey.shade300;
                              statusTextColor = Colors.grey.shade700;
                            }

                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.grey.shade200,
                                    backgroundImage: avatarBackgroundImage,
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          technician.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(Icons.star, color: Colors.amber, size: 16),
                                            SizedBox(width: 4),
                                            Text("4.9", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                            SizedBox(width: 4),
                                            Text("(320)", style: TextStyle(color: Colors.grey, fontSize: 13)),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFE8EEF6),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            technician.specialty,
                                            style: TextStyle(
                                              color: Color(0xFF3B5B9B),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: statusBgColor,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          technician.status,
                                          style: TextStyle(
                                            color: statusTextColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ManageTechnicianPage(partnerId: technician.id),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF3B5B9B),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            "Manage",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}