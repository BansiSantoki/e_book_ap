import 'package:e_book/custom_widgets/custombutton.dart';
import 'package:e_book/screens/bookslist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Genre {
  final String name;
  final String image;

  Genre({required this.name, required this.image});
}

class GenrePage extends StatelessWidget {
  GenrePage({super.key});

  final List<Genre> genres = [
    Genre(name: 'Romance', image: 'assets/images/2.jpg'),
    Genre(name: 'Thriller', image: 'assets/images/3.jpg'),
    Genre(name: 'Horror', image: 'assets/images/4.jfif'),
    Genre(name: 'Fantasy', image: 'assets/images/5.jpg'),
    Genre(name: 'Humor', image: 'assets/images/6.jpg'),
    Genre(name: 'Mystery', image: 'assets/images/2.jpg'),
    Genre(name: 'Art', image: 'assets/images/14.jpg'),
    Genre(name: 'Adventure', image: 'assets/images/2.jpg'),
    Genre(name: 'Action', image: 'assets/images/3.jpg'),
    Genre(name: 'Inspiration', image: 'assets/images/4.jfif'),
    Genre(name: 'Philosophy', image: 'assets/images/5.jpg'),
    Genre(name: 'Poetry', image: 'assets/images/6.jpg'),
    Genre(name: 'Spiritual', image: 'assets/images/14.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xFFAF0606),
        title: const Text(
          "Explore by Genre",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        leading: const CustomBackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: genres.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final genre = genres[index];
            return GenreCard(genre: genre);
          },
        ),
      ),
    );
  }
}

class GenreCard extends StatelessWidget {
  final Genre genre;

  const GenreCard({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => BooksScreen(), arguments: genre.name);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              genre.image,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black.withOpacity(0.4),
            ),
            Center(
              child: Text(
                genre.name,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
