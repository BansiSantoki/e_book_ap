import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book/models/bookitems.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addBookToFirestore(BookItem book) async {
    final booksCollection = _firestore.collection('books');

    // Check if the book already exists by title
    final QuerySnapshot result =
        await booksCollection.where('title', isEqualTo: book.title).get();

    if (result.docs.isEmpty) {
      await booksCollection.add({
        'title': book.title,
        'coverImage': book.coverImage,
        'readOnline': book.readOnline,
        'downloadLinks': {
          'pdf': book.downloadLinks.pdf,
        },
        'author': book.author,
        'description': book.description,
        'authorDescription': book.authorDescription,
        'price': book.price,
      });

      print('Book added to Firestore');
    } else {
      print('Book already exists in Firestore');
    }
  }
}
