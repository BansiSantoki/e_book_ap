import 'package:e_book/controllers/book_controller.dart';
import 'package:get/get.dart';

class BooksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BooksController>(() => BooksController());
  }
}
