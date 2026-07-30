import 'package:e_book/config/themes.dart';
import 'package:e_book/controllers/Admincontrollers/admin_login_controller.dart';
import 'package:e_book/controllers/auth_controller.dart';
import 'package:e_book/firebase_options.dart';
import 'package:e_book/screens/Admin/admin_login.dart';
import 'package:e_book/screens/Admin/admin_profile.dart';
import 'package:e_book/screens/Admin/admindashboard.dart';
import 'package:e_book/screens/Admin/managebooks.dart';
import 'package:e_book/screens/Admin/manageorder.dart';
import 'package:e_book/screens/bookdetails.dart';
import 'package:e_book/screens/bookslist.dart';
import 'package:e_book/screens/genre.dart';
import 'package:e_book/screens/homepage.dart';
import 'package:e_book/screens/login.dart';
import 'package:e_book/screens/mainpage.dart';
import 'package:e_book/screens/signup.dart';
import 'package:e_book/screens/splashscreen.dart';
import 'package:e_book/screens/welcomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(AuthController());
  Get.put(AdminLoginController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/welcome', page: () => const welcomePage()),
        GetPage(name: '/main', page: () => MainPage()),
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(
            name: '/bookdetail',
            page: () => BookDetailScreen(book: Get.arguments)),
        GetPage(name: '/genre', page: () => GenrePage()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/signup', page: () => const Signup()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(
          name: '/bookslist',
          page: () => BooksScreen(),
        ),
        GetPage(name: '/adminlogin', page: () => const AdminLogin()),
        GetPage(name: '/admindashboard', page: () => const AdminDashboard()),
        GetPage(name: '/managebooks', page: () => const ManageBooksScreen()),
        GetPage(name: '/adminprofile', page: () => AdminProfilePage()),
        GetPage(name: '/manageorders', page: () => ManageOrdersPage()),
      ],
    );
  }
}
