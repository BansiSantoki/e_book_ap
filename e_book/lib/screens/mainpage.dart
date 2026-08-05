import 'package:e_book/screens/Audios/audio_books.dart';
import 'package:e_book/screens/Orders/order_screen.dart';
import 'package:e_book/screens/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:e_book/screens/homepage.dart';
import 'package:e_book/screens/bookslist.dart';

class MainPage extends StatefulWidget {
  final int initialIndex;

  const MainPage({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // int _selectedIndex = 0;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    HomeScreen(),
    BooksScreen(),
    AudioBooksScreen(),
    OrdersScreen(),
    ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFAF0606),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Books"),
          BottomNavigationBarItem(
              icon: Icon(Icons.audio_file), label: "Audios"),
          BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2), label: "Orders"),
          // BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Details"),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage('assets/icons/profileimage.avif'),
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text("Profile", style: TextStyle(color: Colors.white)));
  }
}
