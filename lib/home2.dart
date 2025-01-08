import 'dart:convert';
import 'package:class_rasel/Global.dart';
import 'package:class_rasel/every%20class/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:video_player/video_player.dart';

class ClassHomePage extends StatefulWidget {
  @override
  _ClassHomePageState createState() => _ClassHomePageState();
}

class _ClassHomePageState extends State<ClassHomePage> {
  Map<String, dynamic>? classData;
  bool isLoading = true;
  final cont alu = Get.find();
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchClassData();
  }

  Future<void> fetchClassData() async {
    String apiUrl = rootApi;
    String token = alu.token;

    try {
      final response = await dio.get(
        '$apiUrl/classes/${alu.classId}',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          classData = response.data;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load class data");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildInfoCard(String title, String value, VoidCallback onEdit) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: Colors.blue),
          onPressed: onEdit,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (classData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text("Failed to load class data"),
            ElevatedButton(
              onPressed: fetchClassData,
              child: Text("Retry"),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                classData!['name'] ?? "Class Home",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    classData!['coverImage'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.blue[300]!, Colors.blue[800]!],
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                buildInfoCard(
                  "Class Name",
                  classData!['name'] ?? "Not set",
                      () => showEditDialog("name", classData!['name'] ?? ""),
                ),
                buildInfoCard(
                  "Location",
                  classData!['location'] ?? "Not set",
                      () => showEditDialog("location", classData!['location'] ?? ""),
                ),
                buildInfoCard(
                  "Description",
                  classData!['description'] ?? "Not set",
                      () => showEditDialog("description", classData!['description'] ?? ""),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void showEditDialog(String field, String currentValue) {
    TextEditingController controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text("Edit $field"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Add your update logic here
              Navigator.pop(context);
            },
            child: Text("Save"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}