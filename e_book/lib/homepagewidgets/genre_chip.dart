import 'package:e_book/screens/bookslist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenreChips extends StatelessWidget {
  const GenreChips({super.key});

  @override
  Widget build(BuildContext context) {
    final genres = [
      {
        'type': 'Romance',
        'icon': 'assets/icons/heart.png',
      },
      {
        'type': 'Fantasy',
        'icon': 'assets/icons/fantasy.png',
      },
      {
        'type': 'Literature',
        'icon': 'assets/icons/literature.png',
      },
      {
        'type': 'Horror',
        'icon': 'assets/icons/thriller.png',
      },
      {
        'type': 'Thriller',
        'icon': 'assets/icons/horror.png',
      },
      {
        'type': 'Humor',
        'icon': 'assets/icons/comedy.png',
      },
    ];

    return SizedBox(
      height: 35,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          itemCount: genres.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => BooksScreen(), arguments: genres[index]['type']);
                },
                child: Chip(
                  avatar: Image.asset(
                    genres[index]['icon']!,
                  ),
                  label: Text(genres[index]['type']!,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: "Poppins")),
                  backgroundColor: Colors.white,
                  materialTapTargetSize:
                      MaterialTapTargetSize.shrinkWrap, // Reduce tap size
                  visualDensity: VisualDensity.compact,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
