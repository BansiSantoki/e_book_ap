import 'package:e_book/controllers/signup_controller.dart';
import 'package:e_book/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final signupCtrl = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFAF0606),
        body: Column(children: [
          ClipPath(
              clipper: OvalBottomBorderClipper(),
              child: Container(
                height: 280,
                color: Colors.black,
                child: Center(
                  child: Text(
                    "SignUp",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )),
          SizedBox(
            height: 30,
          ),
          Expanded(
              child: Form(
            key: signupCtrl.formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextFormField(
                              controller: signupCtrl.nameController,
                              validator: (val) =>
                                  val!.isEmpty ? "Enter your name" : null,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                  hintText: "Full Name",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                  icon: Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextFormField(
                              controller: signupCtrl.emailController,
                              validator: (val) =>
                                  val!.isEmpty ? "Enter your email" : null,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                icon: Icon(
                                  Icons.email,
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextFormField(
                              controller: signupCtrl.passwordController,
                              obscureText: true,
                              validator: (val) => val!.length < 6
                                  ? "Minimum 6 characters"
                                  : null,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                icon: Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextFormField(
                              controller: signupCtrl.phoneController,
                              validator: (val) =>
                                  val!.isEmpty ? "Enter phone number" : null,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: "Phone number",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                icon: Icon(
                                  Icons.phone,
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            height: 50,
                            width: double.infinity,
                            child: Obx(
                              () => signupCtrl.isLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                          color: Colors.white))
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          )),
                                      onPressed: () {
                                        signupCtrl.signUp();
                                      },
                                      child: Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.toNamed('/login');
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ))
        ]));
  }
}
