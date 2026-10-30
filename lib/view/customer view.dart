import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/customer model.dart';
import '../viewmodel/customer viewmodel.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CustomersViewModel>(
      builder: (context, customersViewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFEFF9FF),
          body: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Row(
                  children: [
                    Text(
                      "Customers",
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
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Container(
                  height: 48,
                  width: 330,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Icon(
                          CupertinoIcons.search,
                          size: 18,
                          color: Colors.black54,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            controller: customersViewModel.searchController,
                            onChanged: (value) {
                              customersViewModel.filterCustomers(value);
                            },
                            decoration: const InputDecoration(
                              hintText: "Search customers...",
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 640,
                child: StreamBuilder<QuerySnapshot>(
                  stream: customersViewModel.getUsersStream(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.hasError) {
                      return Center(child: Text('Error :: ${userSnapshot.error}'));
                    }
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (userSnapshot.hasData) {
                      customersViewModel.updateCustomers(userSnapshot.data!.docs);

                      return StreamBuilder<QuerySnapshot>(
                        stream: customersViewModel.getBookingsStream(),
                        builder: (context, bookingSnapshot) {
                          if (customersViewModel.filteredCustomers.isEmpty) {
                            return const Center(
                              child: Text("No matching customers found", style: TextStyle(color: Colors.grey)),
                            );
                          }

                          return ListView.builder(
                            itemCount: customersViewModel.filteredCustomers.length,
                            itemBuilder: (context, index) {
                              var doc = customersViewModel.filteredCustomers[index];
                              var userData = doc.data() as Map<String, dynamic>;
                              CustomerModel customer = CustomerModel.fromMap(userData, doc.id);

                              String phoneNo = userData['phoneno'] ?? userData['phone'] ?? customer.phone;

                              ImageProvider avatarImage;
                              if (customer.profileImageUrl != null && customer.profileImageUrl!.startsWith('http')) {
                                avatarImage = NetworkImage(customer.profileImageUrl!);
                              } else {
                                avatarImage = const AssetImage("lib/image/admin logo.jpeg");
                              }

                              int activeJobsCount = 0;
                              int totalHistoryJobs = 0;

                              if (bookingSnapshot.hasData) {
                                var userBookings = bookingSnapshot.data!.docs.where((bDoc) {
                                  var bData = bDoc.data() as Map<String, dynamic>;
                                  return bData['userId'] == customer.id;
                                }).toList();

                                totalHistoryJobs = userBookings.length;
                                activeJobsCount = userBookings.where((bDoc) {
                                  var bData = bDoc.data() as Map<String, dynamic>;
                                  String status = bData['status']?.toString().toLowerCase() ?? '';
                                  return status == 'pending' || status == 'accepted' || status == 'upcoming' || status == 'active';
                                }).length;
                              }

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                child: Container(
                                  height: 110,
                                  width: 330,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius: BorderRadius.circular(25),
                                            image: DecorationImage(
                                              image: avatarImage,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 12),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  customer.name,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2),
                                                  child: Text(
                                                    phoneNo.isNotEmpty ? phoneNo : 'No phone number',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.blue,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 8),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 24,
                                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                                        decoration: BoxDecoration(
                                                          color: activeJobsCount > 0 ? const Color(0xFFE2F6EA) : Colors.grey.shade100,
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            activeJobsCount > 0 ? "Active Booking" : "No Active Job",
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: activeJobsCount > 0 ? Colors.green : Colors.grey,
                                                              fontWeight: FontWeight.w800,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Container(
                                                        height: 24,
                                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                                        decoration: BoxDecoration(
                                                          color: const Color(0xFFE2EAF4),
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "History: $totalHistoryJobs jobs",
                                                            style: const TextStyle(
                                                              fontSize: 11,
                                                              color: Colors.blue,
                                                              fontWeight: FontWeight.w800,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}