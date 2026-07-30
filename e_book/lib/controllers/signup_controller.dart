import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/messages.dart'; // for successMessage and errorMessage

class SignupController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  RxBool isLoading = false.obs;

  void signUp() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Get user UID
      String uid = userCredential.user!.uid;

      // Save additional user info in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'uid': uid,
        'profilePic': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
      showsuccessMessage(Get.context!, "Signup Successful");
      Get.offAllNamed('/main');
    } catch (e) {
      print("Signup Error: $e");
      showerrorMessage(Get.context!, "Error! Try again");
    }
    isLoading.value = false;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
