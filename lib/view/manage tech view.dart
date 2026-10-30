import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/manage tech model.dart';
import '../viewmodel/manage tech viewmodel.dart';

class ManageTechnicianPage extends StatelessWidget {
  final String? partnerId;

  const ManageTechnicianPage({super.key, this.partnerId});

  @override
  Widget build(BuildContext context) {
    String docId = partnerId ?? 'sample_partner';

    return Consumer<ManageTechnicianViewModel>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Color(0xFFF4F6FA),
          body: SafeArea(
            child: StreamBuilder<DocumentSnapshot>(
              stream: provider.getTechnicianStream(docId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
                ManageTechnicianModel tech = ManageTechnicianModel.fromMap(data);

                return ListView(
                  padding: EdgeInsets.all(15),
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(CupertinoIcons.arrow_left, size: 22),
                        ),
                        SizedBox(width: 15),
                        Text(
                          "Manage Technician",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Technician Profile",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundImage: AssetImage("lib/image/profile3.jpg"),
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tech.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  tech.category,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: tech.status == "Approved" ? Colors.green.shade50 : Colors.orange.shade50,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        tech.status,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: tech.status == "Approved" ? Colors.green[800] : Colors.orange[800],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(CupertinoIcons.star_fill, color: Colors.amber, size: 13),
                                    SizedBox(width: 2),
                                    Text(
                                      "4.9",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      " (42 Jobs)",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Government ID Verification",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ID Type: ${tech.idType}", style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("ID Number: ${tech.idNumber}", style: TextStyle(color: Colors.black87)),
                          SizedBox(height: 10),
                          Text("Uploaded Photos:", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              tech.frontImg.isNotEmpty
                                  ? Image.network(tech.frontImg, height: 70, width: 100, fit: BoxFit.cover)
                                  : Container(
                                height: 70,
                                width: 100,
                                color: Colors.grey.shade200,
                                child: Center(child: Text("No Front ID", style: TextStyle(fontSize: 10))),
                              ),
                              SizedBox(width: 10),
                              tech.backImg.isNotEmpty
                                  ? Image.network(tech.backImg, height: 70, width: 100, fit: BoxFit.cover)
                                  : Container(
                                height: 70,
                                width: 100,
                                color: Colors.grey.shade200,
                                child: Center(child: Text("No Back ID", style: TextStyle(fontSize: 10))),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Experience & Certificates",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Years of Experience: ${tech.yearsExp}", style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("Qualification: ${tech.qualification}", style: TextStyle(color: Colors.black87)),
                          SizedBox(height: 4),
                          Text("Description: ${tech.workDesc}", style: TextStyle(color: Colors.black54, fontSize: 13)),
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    provider.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          ),
                          onPressed: () => provider.updateVerificationStatus(context, partnerId, "Approved", true, data),
                          child: Text("Approve Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          ),
                          onPressed: () => provider.updateVerificationStatus(context, partnerId, "Rejected", false, data),
                          child: Text("Reject", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}