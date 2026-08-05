import 'package:e_book/controllers/Admincontrollers/admin_login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AdminLoginController admincontroller = Get.put(AdminLoginController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 45.0, bottom: 20.0),
              color: const Color(0xFFAF0606),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Admin Dashboard',
                          style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.none,
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 60,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/adminprofile');
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                                'https://example.com/path_to_profile_picture.jpg'), //
                            child:
                                admincontroller.adminData['profilePic'] == null
                                    ? Icon(Icons.person, color: Colors.white)
                                    : null,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.exit_to_app,
                              color: Colors.white),
                          onPressed: () {
                            admincontroller.logoutAdmin();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: "Poppins"),
                          children: [
                            TextSpan(text: 'Welcome Admin ✌️ '),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Admin Dashboard Buttons
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildDashboardCard(
                      title: 'Manage Books',
                      icon: Icons.book,
                      onTap: () => Get.toNamed('/managebooks'),
                    ),
                    const SizedBox(height: 30),
                    _buildDashboardCard(
                      title: 'Manage Orders',
                      icon: Icons.shopping_cart,
                      onTap: () => Get.toNamed('/manageorders'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminOption({
    required String title,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 15),
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontFamily: "Poppins", fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
