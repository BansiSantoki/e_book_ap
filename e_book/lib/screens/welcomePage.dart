import 'package:e_book/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:e_book/config/themes.dart';
import 'package:get/get.dart';

class welcomePage extends StatelessWidget {
  const welcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/bg.jpg', // Add your background image in assets
            fit: BoxFit.cover,
          ),
          // Dark Overlay
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),

              Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFAF0606),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    'assets/images/Vector.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Title
              const Text(
                'E - Book Store',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 250),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
                ),
                child: Text(
                  'Get started',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              const SizedBox(height: 90),
              GestureDetector(
                onTap: () {
                  Get.toNamed('/adminlogin');
                },
                child: const Text(
                  '🔐 Access Admin Mode',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
