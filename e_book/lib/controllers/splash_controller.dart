import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    splashController();
  }

  void splashController() {
    print("SplashController: Timer started");

    Future.delayed(Duration(seconds: 7), () async {
      final user = auth.currentUser;

      if (user != null) {
        // Check if the user is an admin
        final adminDoc =
            await firestore.collection('admin').doc(user.uid).get();

        if (adminDoc.exists) {
          Get.offAllNamed('/admindashboard');
        } else {
          Get.offAllNamed('/main');
        }
      } else {
        Get.offAllNamed('/welcome');
      }
    });
  }
}
