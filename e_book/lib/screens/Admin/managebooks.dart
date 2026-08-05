import 'package:e_book/config/messages.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ManageBooksScreen extends StatelessWidget {
  const ManageBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFFAF0606),
        leading: const BackButton(color: Colors.white),
        title: const Text('Books',
            style: TextStyle(
                fontFamily: "Century Gothic",
                color: Colors.white,
                fontSize: 16)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('books').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFFAF0606)));
          }

          final books = snapshot.data!.docs;

          if (books.isEmpty) {
            return const Center(
              child: Text('No books found',
                  style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              final bookId = book.id;
              final data = book.data() as Map<String, dynamic>;

              return Dismissible(
                key: Key(bookId),
                direction: DismissDirection.endToStart,
                background: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 246, 105, 95),
                        Color(0xFF8B0000),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      // stops: [0.0, 0.5],
                    ),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  _deleteBook(bookId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Book deleted"),
                      backgroundColor: Color(0xFFAF0606),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          data['coverImage'] ??
                              'https://via.placeholder.com/80',
                          height: 100,
                          width: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['title'] ?? 'No Title',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Author: ${data['author'] ?? 'Unknown'}",
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Price: ₹${data['price'] ?? 'Free'}",
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _editBook(context, book),
                        icon: const Icon(Icons.edit, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _deleteBook(String bookId) async {
    await FirebaseFirestore.instance.collection('books').doc(bookId).delete();
  }

  void _editBook(BuildContext context, DocumentSnapshot book) {
    final currentPrice = book['price']?.toString() ?? 'Free';

    showDialog(
      context: context,
      builder: (context) {
        TextEditingController priceController =
            TextEditingController(text: currentPrice);

        return AlertDialog(
          title: const Text(
            'Edit Price',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            style: TextStyle(fontSize: 14),
            controller: priceController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Price',
              hintText: 'Enter the new price',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel', style: TextStyle(fontSize: 16)),
            ),
            TextButton(
              onPressed: () async {
                final newPrice = priceController.text.trim();

                if (newPrice.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('books')
                      .doc(book.id)
                      .update({'price': newPrice});

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Price updated successfully"),
                      backgroundColor: Color(0xFFAF0606),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Save', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }
}
