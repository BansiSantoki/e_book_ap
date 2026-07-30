import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBackButton extends StatelessWidget {
  final String imagePath;
  final double size;

  const CustomBackButton({
    super.key,
    this.imagePath = 'assets/icons/back.png',
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Get.back(),
      icon: Image.asset(
        imagePath,
        width: size,
        height: size,
      ),
    );
  }
}
