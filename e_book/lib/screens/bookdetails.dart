import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:e_book/config/messages.dart';
import 'package:e_book/controllers/auth_controller.dart';
import 'package:e_book/custom_widgets/custombutton.dart';
import 'package:e_book/screens/Orders/checkout_screen.dart';
import 'package:e_book/screens/pdf_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_book/models/bookitems.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class BookDetailScreen extends StatefulWidget {
  final BookItem book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool isCheckingPdf = true;
  bool pdfAvailable = false;
  int? updatedPrice;
  bool isDownloading = false;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkPdfAvailability();
    fetchLatestBookData();
    checkIfFavorite();
  }

  Future<void> checkIfFavorite() async {
    final authController = Get.find<AuthController>();
    final userId = authController.auth.currentUser?.uid;

    if (userId == null) return;

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final favorites = userDoc.data()?['favorites'] as List<dynamic>?;

    if (favorites != null) {
      bool exists = favorites.any((item) => item['title'] == widget.book.title);
      setState(() {
        isFavorite = exists;
      });
    }
  }

  Future<void> fetchLatestBookData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('books')
          .where('title', isEqualTo: widget.book.title)
          .limit(1)
          .get();

      if (doc.docs.isNotEmpty) {
        final bookData = doc.docs.first.data();
        setState(() {
          updatedPrice = bookData['price'];
        });
      }
    } catch (e) {
      print('Error fetching updated book data: $e');
    }
  }

  Future<void> checkPdfAvailability() async {
    if (widget.book.downloadLinks.pdf.isEmpty) {
      setState(() {
        pdfAvailable = false;
        isCheckingPdf = false;
      });
      return;
    }

    try {
      final response =
          await http.head(Uri.parse(widget.book.downloadLinks.pdf));
      setState(() {
        pdfAvailable = response.statusCode == 200;
        isCheckingPdf = false;
      });
    } catch (e) {
      setState(() {
        pdfAvailable = false;
        isCheckingPdf = false;
      });
      print('Error checking PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const CustomBackButton(),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: () {
              toggleFavorite(widget.book);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Book Image
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.6),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    book.coverImage,
                    width: 200,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                book.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "Author :  ${book.author}",
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     infoColumn("Publish Year", book.firstPublishYear.toString()),
              //   ],
              // ),
              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showsuccessMessage(Get.context!, "Proceed to checkout");
                        Get.to(() => CheckoutScreen(
                            book: book, price: updatedPrice ?? book.price));
                      },
                      icon: Icon(Icons.shopping_cart, color: Colors.white),
                      label: Text(
                        "BUY Rs. ${updatedPrice ?? book.price}",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFAF0606),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              if (isCheckingPdf)
                CircularProgressIndicator(color: Color(0xFFAF0606))
              else if (pdfAvailable)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await handlePdfDownload(book);
                        },
                        icon: Icon(Icons.book, color: Colors.white),
                        label: Text(
                          "READ BOOK",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFAF0606),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                )
              else
                SizedBox.shrink(),

              SizedBox(
                height: 10,
              ),
              // About Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFAF5C5C),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("About book",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 6),
                    Text(
                      book.description,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 14),
                    Text("About Author",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 6),
                    Text(
                      book.authorDescription,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoColumn(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  void toggleFavorite(BookItem book) async {
    try {
      final authController = Get.find<AuthController>();
      final userId = authController.auth.currentUser?.uid;

      if (userId == null) {
        showerrorMessage(Get.context!, 'User not logged in.');
        return;
      }

      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      final userDoc = await userRef.get();
      final favorites = userDoc.data()?['favorites'] as List<dynamic>? ?? [];

      final bookData = {
        'title': book.title,
        'author': book.author,
        'coverImage': book.coverImage,
        'description': book.description,
        'authorDescription': book.authorDescription,
        'pdfLink': book.downloadLinks.pdf,
        'price': book.price,
      };

      bool exists = favorites.any((item) => item['title'] == book.title);

      if (exists) {
        await userRef.update({
          'favorites': FieldValue.arrayRemove([bookData])
        });
        setState(() {
          isFavorite = false;
        });
        showsuccessMessage(Get.context!, 'Removed from favorites 💔');
      } else {
        await userRef.update({
          'favorites': FieldValue.arrayUnion([bookData])
        });
        setState(() {
          isFavorite = true;
        });
        showsuccessMessage(Get.context!, 'Book added to favorites ❤️');
      }
    } catch (e) {
      print('Error adding to favorites: $e');
      showerrorMessage(Get.context!, 'Failed to add to favorites');
    }
  }

  Future<void> handlePdfDownload(BookItem book) async {
    if (isDownloading) return;

    setState(() {
      isDownloading = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Color(0xFFAF0606),
              ),
              SizedBox(height: 20),
              Text(
                "Your book is getting ready...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontFamily: 'Century Gothic',
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        );
      },
    );

    String fileName = book.title.replaceAll(' ', '_') + ".pdf";
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = "${appDocDir.path}/$fileName";

    File file = File(filePath);

    if (await file.exists()) {
      // 📂 Already downloaded
      Navigator.pop(context);
      setState(() {
        isDownloading = false;
      });
      Get.to(() => PDFViewerScreen(pdfPath: filePath, isLocalFile: true));
    } else {
      try {
        Dio dio = Dio();
        await dio.download(book.downloadLinks.pdf, filePath);
        Navigator.pop(context);
        setState(() {
          isDownloading = false;
        });
        Get.to(() => PDFViewerScreen(pdfPath: filePath, isLocalFile: true));
      } catch (e) {
        Navigator.pop(context);
        setState(() {
          isDownloading = false;
        });
        Get.snackbar('Download Failed', 'Could not download the book.');
        print('Error downloading file: $e');
      }
    }
  }
}
