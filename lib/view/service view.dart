import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/service model.dart';
import '../viewmodel/service viewmodel.dart';

class ServiceCategoriesPage extends StatelessWidget {
  const ServiceCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceCategoriesViewModel>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Color(0xFFF4F6FA),
          body: Center(
            child: Container(
              width: 360,
              height: 800,
              color: Color(0xFFF4F6FA),
              child: StreamBuilder<QuerySnapshot>(
                stream: provider.getCategoriesStream(),
                builder: (context, snapshot) {
                  int categoryCount = snapshot.hasData ? snapshot.data!.docs.length : 0;

                  return ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 25, left: 15, right: 15, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(CupertinoIcons.back, color: Colors.black),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 80.0),
                              child: Text(
                                "Service Categories",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Add New Category",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Category Name",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 6),
                              Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextField(
                                  controller: provider.categoryNameController,
                                  decoration: InputDecoration(
                                    hintText: "e.g., Roofing & Siding",
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              GestureDetector(
                                onTap: () => provider.addCategory(context),
                                child: Container(
                                  height: 42,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "+ Add Category",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Active Categories ($categoryCount)",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: snapshot.connectionState == ConnectionState.waiting
                              ? Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: CircularProgressIndicator()),
                          )
                              : !snapshot.hasData || snapshot.data!.docs.isEmpty
                              ? Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: Text("No categories found")),
                          )
                              : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var doc = snapshot.data!.docs[index];
                              var data = doc.data() as Map<String, dynamic>;
                              ServiceCategoriesModel category = ServiceCategoriesModel.fromMap(data, doc.id);

                              return ListTile(
                                title: Text(
                                  category.title,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                trailing: IconButton(
                                  onPressed: () => provider.deleteCategory(category.id),
                                  icon: Icon(CupertinoIcons.delete, color: Colors.red),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}