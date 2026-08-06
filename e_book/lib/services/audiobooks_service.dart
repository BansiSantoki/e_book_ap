import 'dart:convert';
import 'package:e_book/models/audiobooksmodel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AudiobookService {
  static Future<List<AudioBooks>> fetchBooks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const String cacheKey = 'audiobook_cache';

    String? cachedData = prefs.getString(cacheKey);
    if (cachedData != null) {
      print('Loading audiobooks from cache..');
      final List decoded = jsonDecode(cachedData);
      return decoded.map((item) => AudioBooks.fromJson(item)).toList();
    }

    final url = 'https://librivox.org/api/feed/audiobooks?format=json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List books = json.decode(response.body)['books'];

      final List<AudioBooks> audiobooks =
          books.map((book) => AudioBooks.fromJson(book)).toList();

      for (int i = 0; i < audiobooks.length; i++) {
        final image = await fetchCoverImage(audiobooks[i].title);
        audiobooks[i].coverImage = image;
        books[i]['cover_image'] = image;
      }

      await prefs.setString(cacheKey, json.encode(books));

      return audiobooks;
    } else {
      throw Exception('Failed to load books');
    }
  }

  static Future<String?> fetchCoverImage(String title) async {
    final query = Uri.encodeComponent(title);
    final url = 'https://openlibrary.org/search.json?title=$query';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final docs = data['docs'];
      if (docs != null &&
          docs is List &&
          docs.isNotEmpty &&
          docs[0]['cover_i'] != null) {
        final coverId = docs[0]['cover_i'];
        return 'https://covers.openlibrary.org/b/id/$coverId-L.jpg';
      }

      // if (data['docs'].isNotEmpty && data['docs'][0]['cover_i'] != null) {
      //   final coverId = data['docs'][0]['cover_i'];

      //   return 'https://covers.openlibrary.org/b/id/$coverId-L.jpg';
      // }
    }
    return null;
  }
}
