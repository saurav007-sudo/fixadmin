// lib/view/order_details_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/orderdetails model.dart';
import '../viewmodel/orderdetails viewmodel.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDetailsViewModel>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFEFF9FF),
          body: StreamBuilder<DocumentSnapshot>(
            stream: provider.getOrderDetailsStream(widget.orderId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Scaffold(
                  appBar: AppBar(backgroundColor: Colors.white),
                  body: const Center(
                    child: Text(
                      "Order details not found",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                );
              }

              var orderData = snapshot.data!.data() as Map<String, dynamic>;
              OrderDetailsModel order = OrderDetailsModel.fromMap(orderData, widget.orderId);

              String? customerUserId = orderData['userId'] ?? orderData['customerId'];

              Color statusBgColor;
              Color statusTextColor;
              String statusLabel;

              if (order.status == 'completed' || order.status == 'closed') {
                statusBgColor = const Color(0xFFDDF8F0);
                statusTextColor = Colors.green.shade800;
                statusLabel = "Completed";
              } else if (order.status == 'accepted' || order.status == 'upcoming' || order.status == 'active') {
                statusBgColor = const Color(0xFFE8F4FF);
                statusTextColor = Colors.blue.shade800;
                statusLabel = "Active";
              } else {
                statusBgColor = const Color(0xFFFFF3DB);
                statusTextColor = Colors.orange;
                statusLabel = "Pending";
              }

              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            CupertinoIcons.arrow_left,
                            size: 24,
                            color: Colors.black,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            "Order Details",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Container(
                      height: 105,
                      width: 330,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Icon(
                                CupertinoIcons.wrench,
                                size: 22,
                                color: Colors.blue,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Order ${order.bookingId}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      order.serviceName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      "Technician: ${order.technicianName}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 24,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: statusBgColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      statusLabel,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: statusTextColor,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    "₹${order.totalAmount.toStringAsFixed(0)}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15, left: 15, bottom: 8),
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.person, size: 16, color: Colors.blue),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            "Customer Details",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<DocumentSnapshot>(
                    future: customerUserId != null
                        ? FirebaseFirestore.instance.collection('users').doc(customerUserId).get()
                        : Future.value(null),
                    builder: (context, userSnapshot) {
                      String displayName = order.customerName;
                      String displayPhone = order.customerPhone;

                      if (userSnapshot.hasData && userSnapshot.data != null && userSnapshot.data!.exists) {
                        var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                        displayName = userData['name'] ?? userData['fullName'] ?? order.customerName;
                        displayPhone = userData['phoneno'] ?? userData['phone'] ?? order.customerPhone;
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          height: 75,
                          width: 330,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.person_fill,
                                    size: 20,
                                    color: Colors.blue,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        displayName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          displayPhone,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w700,
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
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15, left: 15, bottom: 8),
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.doc_text, size: 16, color: Colors.blue),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            "Service Details",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      height: 120,
                      width: 330,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(CupertinoIcons.tag, size: 14, color: Colors.black54),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Category",
                                    style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  order.category,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.black),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  const Icon(CupertinoIcons.calendar, size: 14, color: Colors.black54),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Scheduled Date",
                                      style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    order.scheduledDate,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  const Icon(CupertinoIcons.location_solid, size: 14, color: Colors.black54),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Location",
                                      style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    order.location,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(CupertinoIcons.money_dollar, size: 16, color: Colors.blue),
                                Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Text(
                                    "Price Breakdown",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Service charge", style: TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w600)),
                                  Text("₹${order.basePrice.toStringAsFixed(0)}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.black)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Customer service fee (5%)", style: TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w600)),
                                  Text("₹${order.serviceFee.toStringAsFixed(0)}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.black)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Platform fee", style: TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w600)),
                                  Text("₹${order.platformFee.toStringAsFixed(0)}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.black)),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Divider(color: Colors.black12),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Total", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.black)),
                                Text("₹${order.totalAmount.toStringAsFixed(0)}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.black)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}