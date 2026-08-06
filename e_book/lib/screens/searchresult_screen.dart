import 'package:e_book/screens/bookdetails.dart';
import 'package:e_book/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:e_book/services/book_service.dart';
import 'package:e_book/models/bookitems.dart';
import 'package:get/get.dart';

class SearchResultScreen extends StatefulWidget {
  final String searchQuery;

  const SearchResultScreen({super.key, required this.searchQuery});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late Future<List<BookItem>> _futureBooks;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _futureBooks = BookService.fetchBooks(genre: widget.searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Results for '${widget.searchQuery}'",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: Color(0xFFAF0606),
      ),
      body: FutureBuilder<List<BookItem>>(
        future: _futureBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: Color(0xFFAF0606)));
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('No books found.',
                    style: TextStyle(color: Colors.white)));
          } else {
            final books = snapshot.data!;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  leading: Image.network(book.coverImage,
                      width: 50, height: 80, fit: BoxFit.cover),
                  title:
                      Text(book.title, style: TextStyle(color: Colors.white)),
                  subtitle: Text(book.author,
                      style: TextStyle(color: Colors.white70)),
                  onTap: () async {
                    await _firestoreService.addBookToFirestore(book);
                    Get.to(BookDetailScreen(book: book));
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
