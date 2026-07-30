import 'package:flutter/material.dart';
import 'package:e_book/models/bookitems.dart';
import 'package:e_book/services/book_service.dart';
import 'package:get/get.dart';

// class BookCardList extends StatelessWidget {
//   const BookCardList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final books = [
//       {
//         'title': 'Rich dad poor dad',
//         'author': 'Robert Kiyosaki',
//         'image': 'assets/images/1.webp'
//       },
//       {
//         'title': 'How Innovation Works',
//         'author': 'Matt Ridley',
//         'image': 'assets/images/4.webp'
//       },
//       {
//         'title': 'Company of One',
//         'author': 'Paul Jarvis',
//         'image': 'assets/images/6.jfif'
//       },
//       {
//         'title': 'Company of One',
//         'author': 'Paul Jarvis',
//         'image': 'assets/images/7.jfif'
//       },
//       {
//         'title': 'Company of One',
//         'author': 'Paul Jarvis',
//         'image': 'assets/images/6.jfif'
//       },
//     ];

//     return SizedBox(
//       height: 200,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: books.length,
//         itemBuilder: (context, index) {
//           return Container(
//             width: 120,
//             margin: const EdgeInsets.symmetric(horizontal: 2.0),
//             child: Column(
//               children: [
//                 Container(
//                   height: 140,
//                   width: 100,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     color: Colors.grey.shade300,
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12.0),
//                     child: Image.asset(
//                       books[index]['image']!,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   books[index]['title']!,
//                   style: const TextStyle(color: Colors.white, fontSize: 10),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

class InterestCard extends StatelessWidget {
  const InterestCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BookItem>>(
      future: BookService.fetchBooks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFFAF0606)));
        } else if (snapshot.hasError) {
          return const Center(
              child: Text("Failed to load books",
                  style: TextStyle(color: Colors.white)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text("No books found",
                  style: TextStyle(color: Colors.white)));
        }

        final books = snapshot.data!;

        return ListView.builder(
          itemCount: books.length > 20 ? 20 : books.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final book = books[index];

            return InkWell(
              onTap: () {
                Get.toNamed(
                  '/bookdetail',
                  arguments: book,
                );
              },
              child: Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 130,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade300,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            book.coverImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'By: ${book.author}',
                              style: const TextStyle(fontSize: 10),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Read Online: ${book.readOnline.isNotEmpty ? "Available" : "N/A"}',
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
