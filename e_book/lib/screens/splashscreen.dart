import 'package:e_book/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashController splashController;

  @override
  void initState() {
    super.initState();
    splashController = Get.put(SplashController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAF0606),
      body: Center(
        child: Lottie.asset("assets/animations/Animation1.json"),
      ),
    );
  }
}
