import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book/config/messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminLoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxMap<String, dynamic> adminData = <String, dynamic>{}.obs;

  final formKey = GlobalKey<FormState>();

  Future<void> loginAdmin() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      UserCredential userCred = await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await fetchAdminData(userCred.user!.uid);

      final adminDoc =
          await _firestore.collection('admin').doc(userCred.user!.uid).get();

      if (adminDoc.exists) {
        Get.offAllNamed('/admindashboard');
        showsuccessMessage(Get.context!, "Welcome Admin, Login Successful");
      } else {
        await auth.signOut();
        showerrorMessage(
            Get.context!, "Access Denied! You are not authorized as an admin");
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Error", "Invalid admin",
          backgroundColor: Color(0xFFAF0606), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAdminData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('admin').doc(uid).get();
      if (doc.exists) {
        adminData.value = doc.data() as Map<String, dynamic>;
        print("Admin data fetched: ${adminData.value}");
      }
    } catch (e) {
      print("Error fetching admin data: $e");
    }
  }

  Future<void> logoutAdmin() async {
    await auth.signOut();
    Get.offAllNamed('/adminlogin');
  }
}
