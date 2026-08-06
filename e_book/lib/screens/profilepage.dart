import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book/controllers/auth_controller.dart';
import 'package:e_book/models/bookitems.dart';
import 'package:e_book/screens/bookdetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController authController = Get.put(AuthController());
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    await authController.fetchUserData();
    setState(() {});
  }

  Future<void> _removeFromFavorites(Map<String, dynamic> book) async {
    final userId = authController.auth.currentUser?.uid;
    if (userId == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final snapshot = await docRef.get();

    if (snapshot.exists) {
      List<dynamic> currentFavorites = snapshot.data()?['favorites'] ?? [];

      currentFavorites.removeWhere((item) => item['title'] == book['title']);

      await docRef.update({'favorites': currentFavorites});

      setState(() {
        selectedIndex = null;
      });
    }
  }

  void _showEditNameDialog() {
    TextEditingController nameController = TextEditingController(
      text: authController.userData['name'],
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Edit Name",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: "Name"),
        ),
        actions: [
          TextButton(
            child: const Text(
              "Cancel",
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Save", style: TextStyle(fontSize: 16)),
            onPressed: () async {
              String newName = nameController.text.trim();
              if (newName.isNotEmpty) {
                final userId = authController.auth.currentUser?.uid;
                if (userId != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .update({'name': newName});
                  authController.fetchUserData(); // Refresh data
                  Navigator.pop(context);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _changeProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final localPath = pickedFile.path;

      final userId = authController.auth.currentUser?.uid;
      if (userId == null) return;

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'profilePic': localPath});

        await authController.fetchUserData();

        setState(() {});
      } catch (e) {
        print('Error uploading profile picture: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            color: Color(0xFFAF0606),
            width: double.infinity,
            height: 400,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () {
                          authController.signout();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: _changeProfilePicture,
                  child: Obx(() {
                    String? profilePic = authController.userData['profilePic'];
                    return CircleAvatar(
                      radius: 50,
                      backgroundImage: profilePic != null &&
                              profilePic.isNotEmpty
                          ? (profilePic.startsWith('http')
                              ? NetworkImage(profilePic +
                                  "?t=${DateTime.now().millisecondsSinceEpoch}")
                              : FileImage(File(profilePic))) as ImageProvider
                          : const AssetImage('assets/icons/profileimage.avif'),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                Obx(() => Text(
                      authController.userData['name'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                const SizedBox(height: 5),
                Obx(() => Text(
                      authController.userData['email'] ?? '',
                      style: const TextStyle(color: Colors.white70),
                    )),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    _showEditNameDialog();
                  },
                  icon: const Icon(Icons.edit, size: 16, color: Colors.red),
                  label: const Text(
                    "Edit Profile",
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Optional: rounded corners
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Your Favorites",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(child: _buildFavoriteBooksList()),
        ],
      ),
    );
  }

  Widget _buildFavoriteBooksList() {
    final userId = authController.auth.currentUser?.uid;
    if (userId == null) {
      return const Center(
        child: Text('Not logged in', style: TextStyle(color: Colors.white)),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFFAF0606)));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(
              child:
                  Text('No data found', style: TextStyle(color: Colors.white)));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final favorites = data['favorites'] as List<dynamic>? ?? [];

        if (favorites.isEmpty) {
          return const Center(
              child: Text('No favorites yet.',
                  style: TextStyle(color: Colors.white)));
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final book = favorites[index];
            bool isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () {
                BookItem selectedBook = BookItem(
                  title: book['title'] ?? '',
                  author: book['author'] ?? '',
                  coverImage: book['coverImage'] ?? '',
                  readOnline: book['readOnline'] ?? '',
                  downloadLinks: DownloadLinks(
                    pdf: book['pdfLink'] ?? '',
                    epub: book['epubLink'] ?? '', // add this
                  ),
                  description: book['description'] ?? '',
                  authorDescription: book['authorDescription'] ?? '',
                  price: book['price'] ?? 0,
                );

                Get.to(() => BookDetailScreen(book: selectedBook));
              },
              onLongPress: () async {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            book['coverImage'],
                            height: 120,
                            width: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 90,
                          child: Text(
                            book['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                  if (isSelected)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: () => _removeFromFavorites(book),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFAF0606),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(Icons.delete,
                              size: 16, color: Colors.white),
                        ),
                      ),
                    )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
