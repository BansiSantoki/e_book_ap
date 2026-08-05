import 'package:e_book/custom_widgets/custombutton.dart';
import 'package:e_book/screens/Audios/audiobook_play.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_book/models/audiobooksmodel.dart';
import 'package:e_book/services/audiobooks_service.dart';

class AudioBooksScreen extends StatefulWidget {
  @override
  _AudioBooksScreenState createState() => _AudioBooksScreenState();
}

class _AudioBooksScreenState extends State<AudioBooksScreen> {
  List<AudioBooks> _audioBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAudioBooks();
  }

  Future<void> _loadAudioBooks() async {
    try {
      final fetchedBooks = await AudiobookService.fetchBooks();

      // for (var book in fetchedBooks) {
      //   final cover = await AudiobookService.fetchCoverImage(book.title);
      //   book.coverImage = cover;
      // }

      setState(() {
        _audioBooks = fetchedBooks;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading audiobooks: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audiobooks",
            style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: Color(0xFFB30000),
        leading: const CustomBackButton(),
      ),
      backgroundColor: Colors.black,
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFFB30000)))
          : _audioBooks.isEmpty
              ? Center(
                  child: Text('No audiobooks found',
                      style: TextStyle(color: Colors.white)))
              : GridView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: _audioBooks.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, index) {
                    final book = _audioBooks[index];
                    return InkWell(
                      onTap: () {
                        Get.to(() => AudiobookPlayerScreen(
                              title: book.title,
                              rssUrl: book.urlRss,
                              coverUrl: book.coverImage ?? '',
                            ));
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
                                  child: book.coverImage != null
                                      ? Image.network(
                                          book.coverImage!,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(Icons.broken_image,
                                                      color: Colors.white),
                                        )
                                      : Image.asset(
                                          "assets/images/1.webp",
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                book.title,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                "By ${book.author}",
                                style: TextStyle(
                                    color: Colors.white60, fontSize: 9),
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
