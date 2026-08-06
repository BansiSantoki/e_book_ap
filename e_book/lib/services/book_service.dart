import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_book/models/bookitems.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookService {
  static Future<List<BookItem>> fetchBooks({String? genre}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final normalizedGenre = genre?.trim().toLowerCase();
    final cacheKey =
        normalizedGenre == null ? 'book_cache' : 'book_cache_$normalizedGenre';

    String? cachedData = prefs.getString(cacheKey);

    if (cachedData != null) {
      print('Loading from cache for ${genre ?? "homepage"}...');
      final List decoded = jsonDecode(cachedData);
      return decoded.map((e) => BookItem.fromJson(e)).toList();
    }

    String apiUrl =
        'https://openlibrary.org/search.json?q=book&has_fulltext=true&limit=20';

    if (genre != null && genre.isNotEmpty) {
      apiUrl =
          'https://openlibrary.org/search.json?q=book&subject=${Uri.encodeComponent(genre)}&has_fulltext=true&limit=30';
    }

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List books = data['docs'];

      List<BookItem> bookItems = [];

      for (var book in books) {
        final String title = book['title'] ?? 'Unknown';
        final String author =
            (book['author_name'] != null && book['author_name'].isNotEmpty)
                ? book['author_name'][0]
                : 'Unknown Author';
        final String coverImage = book['cover_i'] != null
            ? 'https://covers.openlibrary.org/b/id/${book['cover_i']}-L.jpg'
            : 'https://via.placeholder.com/150';
        final String ia =
            book['ia'] != null && book['ia'].isNotEmpty ? book['ia'][0] : '';

        final int? firstPublishYear = book['first_publish_year'];

        String bookDescription = 'No description available';
        if (book['description'] != null) {
          if (book['description'] is String) {
            bookDescription = book['description'];
          } else if (book['description'] is Map &&
              book['description']['value'] != null) {
            bookDescription = book['description']['value'];
          }
        }

// Author description
        String authorDescription = 'No description available';
        if (book['author_key'] != null && book['author_key'].isNotEmpty) {
          final authorResponse = await http.get(Uri.parse(
              'https://openlibrary.org/authors/${book['author_key'][0]}.json'));

          if (authorResponse.statusCode == 200) {
            final authorData = jsonDecode(authorResponse.body);

            if (authorData['bio'] != null) {
              if (authorData['bio'] is String) {
                authorDescription = authorData['bio'];
              } else if (authorData['bio'] is Map &&
                  authorData['bio']['value'] != null) {
                authorDescription = authorData['bio']['value'];
              }
            }
          }
        }

        int price = 800;

        bookItems.add(BookItem(
          title: title,
          author: author,
          coverImage: coverImage,
          readOnline: ia.isNotEmpty ? 'https://archive.org/details/$ia' : '',
          downloadLinks: DownloadLinks(
            pdf:
                ia.isNotEmpty ? 'https://archive.org/download/$ia/$ia.pdf' : '',
            epub: ia.isNotEmpty
                ? 'https://archive.org/download/$ia/$ia.epub'
                : '',
          ),
          description: bookDescription,
          authorDescription: authorDescription,
          firstPublishYear: firstPublishYear,
          price: price,
        ));
      }

      prefs.setString(
          cacheKey, jsonEncode(bookItems.map((e) => e.toJson()).toList()));

      return bookItems;
    } else {
      throw Exception('Failed to load books');
    }
  }
}
