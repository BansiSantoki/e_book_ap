import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book/config/messages.dart';
import 'package:e_book/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void login() async {
    if (formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      try {
        // Authenticate the user with Firebase
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        User? user = userCredential.user;

        if (user != null) {
          // Step 2: Fetch user data from Firestore
          DocumentSnapshot doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (doc.exists) {
            // Step 3: Store in AuthController
            final AuthController authController = Get.find<AuthController>();
            authController.userData.value = doc.data() as Map<String, dynamic>;
          }

          showsuccessMessage(Get.context!, "Welcome, ${user.email}");
          Future.delayed(const Duration(milliseconds: 500), () {
            Get.offNamed('/main');
          });
        }
      } catch (e) {
        String errorMessage = "An error occurred";
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'user-not-found':
              errorMessage = "No user found for that email.";
              break;
            case 'wrong-password':
              errorMessage = "Invalid credential";
              break;
            default:
              errorMessage = "Invalid credential";
          }
        }

        showerrorMessage(Get.context!, errorMessage);
      }
    }
  }

  // Dispose controllers
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
