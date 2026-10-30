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
          backgroundColor: const Color(0xFFEFF9FF),
          body: SafeArea(
            child: StreamBuilder<DocumentSnapshot>(
              stream: provider.getTechnicianStream(docId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
                ManageTechnicianModel tech = ManageTechnicianModel.fromMap(data);

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // App Bar Row
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(CupertinoIcons.arrow_left, size: 24, color: Colors.black),
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          "Manage Technician",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Technician Profile",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.blueAccent,
                            child: Icon(CupertinoIcons.person, color: Colors.white, size: 30),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tech.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tech.category,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Government ID Verification",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          tech.frontImg.isNotEmpty
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(tech.frontImg, height: 70, width: 100, fit: BoxFit.cover),
                          )
                              : Container(
                            height: 70,
                            width: 100,
                            color: Colors.grey.shade200,
                          ),
                          tech.backImg.isNotEmpty
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(tech.backImg, height: 70, width: 100, fit: BoxFit.cover),
                          )
                              : Container(
                            height: 70,
                            width: 100,
                            color: Colors.grey.shade200,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Experience & Certificates",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("No additional certificates provided.", style: TextStyle(color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    provider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => provider.updateVerificationStatus(context, partnerId, "Approved", true, data),
                          child: const Text("Approve"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => provider.updateVerificationStatus(context, partnerId, "Rejected", false, data),
                          child: const Text("Reject"),
                        ),
                      ],
                    ),
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