import 'package:get/get.dart';
import '../models/bookitems.dart';
import '../services/book_service.dart';

class BooksController extends GetxController {
  var books = <BookItem>[].obs;
  var isLoading = false.obs;

  Future<void> loadBooks(String? genre) async {
    if (books.isNotEmpty) return; // prevent reload

    isLoading.value = true;
    try {
      books.value = await BookService.fetchBooks(genre: genre);
    } catch (e) {
      print("Error loading books: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void clearBooks() {
    books.clear();
  }
}
