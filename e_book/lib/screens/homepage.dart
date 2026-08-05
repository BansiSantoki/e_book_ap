import 'package:e_book/homepagewidgets/book_card.dart';
import 'package:e_book/homepagewidgets/book_card_api.dart';
import 'package:e_book/homepagewidgets/genre_chip.dart';
import 'package:e_book/screens/searchresult_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_book/services/book_service.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _handleSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Get.to(() => SearchResultScreen(searchQuery: query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 45.0),
              color: Color(0xFFAF0606),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.book, color: Colors.white, size: 30),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'E-Book!',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: "Poppins"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        icon: Icon(Icons.category, color: Colors.white),
                        onPressed: () {
                          Get.toNamed('/genre');
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: "Poppins"),
                        children: [
                          TextSpan(
                            text: 'Hey Welcome! ✌️ ',
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 16,
                  ),
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (value) => _handleSearch(),
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: 'Search book',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Image.asset('assets/icons/magni.png',
                            height: 20, width: 20),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed:
                              _handleSearch, // <-- handle on tap search button
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 12.0,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Genre Chips
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      'Explore by Genre',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 13),
                  const GenreChips(),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Trending Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Trending',
                style: TextStyle(
                    color: Colors.white, fontSize: 13, fontFamily: 'Poppins'),
              ),
            ),
            const BookCardListFromAPI(),

            const SizedBox(height: 16),

            // Your Interests Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Your Interests',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
            const InterestCard(),
          ],
        ),
      ),
    );
  }
}
