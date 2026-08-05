import 'package:e_book/custom_widgets/custombutton.dart';
import 'package:e_book/screens/bookdetails.dart';
import 'package:e_book/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:e_book/services/book_service.dart';
import 'package:e_book/models/bookitems.dart';
import 'package:get/get.dart';

class BooksScreen extends StatefulWidget {
  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  List<BookItem> _books = [];
  bool _isLoading = true;
  String? genre;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    genre = Get.arguments;
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    try {
      final fetchedBooks = await BookService.fetchBooks(genre: genre);
      setState(() {
        _books = fetchedBooks;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading books: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(genre ?? 'Books',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            )),
        backgroundColor: Color(0xFFAF0606),
        leading: const CustomBackButton(),
      ),
      backgroundColor: Colors.black,
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFFAF0606)))
          : _books.isEmpty
              ? Center(
                  child: Text(
                    'No books found for $genre',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: _books.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, index) {
                    final book = _books[index];
                    return InkWell(
                      onTap: () async {
                        await _firestoreService.addBookToFirestore(book);
                        Get.to(() => BookDetailScreen(book: book));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  book.coverImage,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.broken_image,
                                          color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 8.0, right: 8.0),
                              child: Text(
                                book.title,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                "By ${book.author}",
                                style: TextStyle(
                                    color: Colors.white60, fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
