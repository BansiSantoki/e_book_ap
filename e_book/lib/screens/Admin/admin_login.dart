import 'package:e_book/controllers/Admincontrollers/admin_login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';

class AdminLogin extends StatelessWidget {
  const AdminLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAF0606),
      body: Column(
        children: [
          ClipPath(
            clipper: OvalBottomBorderClipper(),
            child: Container(
              height: 280,
              color: Colors.black,
              child: Center(
                child: Text(
                  "📖 Admin Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: GetBuilder<AdminLoginController>(
              init: AdminLoginController(),
              builder: (controller) {
                return Form(
                  key: controller.formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: controller.emailController,
                          hint: "Admin Email",
                          icon: Icons.email,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Please enter your email";
                            }
                            final emailPattern =
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
                            if (!RegExp(emailPattern).hasMatch(val)) {
                              return "Enter a valid email address";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: controller.passwordController,
                          hint: "Password",
                          icon: Icons.lock,
                          obscure: true,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Please enter your password";
                            }
                            if (val.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 50),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: controller.isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white),
                                )
                              : ElevatedButton(
                                  onPressed: controller.loginAdmin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/welcome');
                          },
                          child: const Text(
                            "Back to Welcome",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    required String? Function(String?) validator,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        style: const TextStyle(fontFamily: "Poppins", fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          icon: Icon(icon, color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
