import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book/controllers/Admincontrollers/admin_login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AdminProfilePage extends StatefulWidget {
  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  final AdminLoginController adminController =
      Get.find(); // Use Get.find() to get the instance

  @override
  void initState() {
    super.initState();
    final userId = adminController.auth.currentUser?.uid;
    if (userId != null) {
      adminController.fetchAdminData(userId);
    }
  }

  Future<void> _changeProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final localPath = pickedFile.path; // Local file path

      final userId = adminController.auth.currentUser?.uid;
      if (userId != null) {
        // Save the local path to Firestore
        await FirebaseFirestore.instance
            .collection('admin')
            .doc(userId)
            .update({'profilePic': localPath});

        adminController.fetchAdminData(userId); // Refresh local data
      }
    }
  }

  void _showEditNameDialog() {
    TextEditingController nameController = TextEditingController(
      text: adminController.adminData['name'],
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Name"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: "Name"),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Save"),
            onPressed: () async {
              String newName = nameController.text.trim();
              if (newName.isNotEmpty) {
                final userId = adminController.auth.currentUser?.uid;
                if (userId != null) {
                  await FirebaseFirestore.instance
                      .collection('admin')
                      .doc(userId)
                      .update({'name': newName});
                  adminController.fetchAdminData(userId); // Refresh data
                  Navigator.pop(context);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (adminController.adminData.isEmpty) {
          return Center(
              child: CircularProgressIndicator(
            color: Color(0xFFAF0606),
          ));
        } else {
          return Column(
            children: [
              Container(
                color: Color(0xFFAF0606),
                width: double.infinity,
                height: 400,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const Text(
                            'Admin Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.logout, color: Colors.white),
                            onPressed: () {
                              adminController.logoutAdmin();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: _changeProfilePicture,
                      child: Obx(() {
                        String? profilePic =
                            adminController.adminData['profilePic'];
                        return CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              profilePic != null && profilePic.isNotEmpty
                                  ? (profilePic.startsWith('http')
                                          ? NetworkImage(profilePic)
                                          : FileImage(File(profilePic)))
                                      as ImageProvider
                                  : const AssetImage('assets/images/5.jpg'),
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    Obx(() => Text(
                          adminController.adminData['name'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    const SizedBox(height: 5),
                    Obx(() => Text(
                          adminController.adminData['email'] ?? '',
                          style: const TextStyle(color: Colors.white70),
                        )),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        _showEditNameDialog();
                      },
                      icon: const Icon(Icons.edit, size: 16, color: Colors.red),
                      label: const Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        }
      }),
    );
  }
}
