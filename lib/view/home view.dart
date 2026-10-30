import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/home model.dart';
import '../viewmodel/home viewmodel.dart';
import 'orderdetails view.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminHomeViewModel>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Color(0xFFEFF9FF),
          body: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Row(
                  children: [
                    Text(
                      "Home",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 225),
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(17),
                          image: DecorationImage(
                            image: NetworkImage("lib/image/admin logo.jpeg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: provider.getBookingsStream(),
                builder: (context, bookingSnapshot) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: provider.getPartnersStream(),
                    builder: (context, partnerSnapshot) {
                      int totalBookings = 0;
                      int completedBookings = 0;
                      double totalRevenue = 0.0;
                      double totalProfit = 0.0;
                      int activeTechnicians = 0;

                      if (bookingSnapshot.hasData) {
                        totalBookings = bookingSnapshot.data!.docs.length;
                        for (var doc in bookingSnapshot.data!.docs) {
                          var data = doc.data() as Map<String, dynamic>;
                          String status = data['status']?.toString().toLowerCase() ?? '';
                          String paymentStatus = data['paymentStatus']?.toString().toLowerCase() ?? '';

                          if (status == 'completed' || status == 'closed') {
                            completedBookings++;
                          }

                          bool isPaid = paymentStatus == 'completed' ||
                              paymentStatus == 'paid' ||
                              status == 'completed' ||
                              status == 'closed';

                          if (isPaid) {
                            double amountPaid = double.tryParse(
                              data['totalAmount']?.toString() ??
                                  data['total']?.toString() ??
                                  data['amount']?.toString() ??
                                  data['price']?.toString() ??
                                  data['basePrice']?.toString() ?? '0',
                            ) ?? 0.0;

                            totalRevenue += amountPaid;
                          }
                        }

                        totalProfit = totalRevenue * 0.10;
                      }

                      if (partnerSnapshot.hasData) {
                        activeTechnicians = partnerSnapshot.data!.docs.where((doc) {
                          var data = doc.data() as Map<String, dynamic>;
                          return data['isVerified'] == true || data['status'] == 'active';
                        }).length;

                        if (activeTechnicians == 0) {
                          activeTechnicians = partnerSnapshot.data!.docs.length;
                        }
                      }

                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                            child: Row(
                              children: [
                                Container(
                                  height: 105,
                                  width: 158,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(CupertinoIcons.time, size: 14, color: Colors.blue),
                                            Padding(
                                              padding: EdgeInsets.only(left: 6),
                                              child: Text(
                                                "No of Bookings",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 12),
                                          child: Text(
                                            "$totalBookings",
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 14),
                                  child: Container(
                                    height: 105,
                                    width: 157,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(CupertinoIcons.checkmark_rectangle, size: 14, color: Colors.blue),
                                              Padding(
                                                padding: EdgeInsets.only(left: 1),
                                                child: Text(
                                                  "Completed Bookings",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 12),
                                            child: Text(
                                              "$completedBookings",
                                              style: TextStyle(
                                                fontSize: 24,
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
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12, left: 15, right: 15),
                            child: Row(
                              children: [
                                Container(
                                  height: 105,
                                  width: 158,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(CupertinoIcons.person_2, size: 14, color: Colors.blue),
                                            Padding(
                                              padding: EdgeInsets.only(left: 6),
                                              child: Text(
                                                "Active Technicians",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 12),
                                          child: Text(
                                            "$activeTechnicians",
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 14),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: 105,
                                      width: 158,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(CupertinoIcons.checkmark_shield, size: 14, color: Colors.blue),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 6),
                                                  child: Text(
                                                    "Total Revenue",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 12),
                                              child: Text(
                                                "₹${totalRevenue.toStringAsFixed(0)}",
                                                style: TextStyle(
                                                  fontSize: 24,
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
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12, left: 15, right: 15),
                            child: Row(
                              children: [
                                Container(
                                  height: 105,
                                  width: 330,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(CupertinoIcons.money_dollar_circle, size: 14, color: Colors.green),
                                            Padding(
                                              padding: EdgeInsets.only(left: 6),
                                              child: Text(
                                                "Profit (10% of Revenue)",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 12),
                                          child: Text(
                                            "₹${totalProfit.toStringAsFixed(0)}",
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, left: 15, bottom: 8),
                child: Text(
                  "Order List",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 400,
                child: StreamBuilder<QuerySnapshot>(
                  stream: provider.getOrderedBookingsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text("No orders found", style: TextStyle(color: Colors.grey)),
                      );
                    }

                    var orderDocs = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: orderDocs.length,
                      itemBuilder: (context, index) {
                        var doc = orderDocs[index];
                        var orderData = doc.data() as Map<String, dynamic>;
                        OrderModel order = OrderModel.fromMap(orderData, doc.id);

                        Color statusBgColor;
                        Color statusTextColor;
                        String statusLabel;

                        if (order.status == 'completed' || order.status == 'closed') {
                          statusBgColor = Color(0xFFDDF8F0);
                          statusTextColor = Colors.green.shade800;
                          statusLabel = "Completed";
                        } else if (order.status == 'accepted' || order.status == 'upcoming' || order.status == 'active') {
                          statusBgColor = Color(0xFFE8F4FF);
                          statusTextColor = Colors.blue.shade800;
                          statusLabel = "Active";
                        } else {
                          statusBgColor = Color(0xFFFFF3DB);
                          statusTextColor = Colors.orange;
                          statusLabel = "Pending";
                        }

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetailsPage(orderId: order.id),
                                ),
                              );
                            },
                            child: Container(
                              height: 65,
                              width: 330,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 36,
                                      width: 36,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFEFF9FF),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Icon(
                                        CupertinoIcons.person_fill,
                                        size: 16,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Order ${order.bookingId}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            order.serviceName,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 24,
                                      padding: EdgeInsets.symmetric(horizontal: 10),
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
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