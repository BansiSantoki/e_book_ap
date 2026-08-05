import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book/controllers/auth_controller.dart';
import 'package:e_book/screens/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final uid = authController.auth.currentUser?.uid;
    print("Current UID: $uid");

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.off(() => MainPage(initialIndex: 0));
          },
        ),
        title: const Text('My Orders',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: Color(0xFFAF0606),
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('uid', isEqualTo: uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No orders yet 📭',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.white24),
            itemBuilder: (context, index) {
              final order = orders[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      order['cover'],
                      height: 60,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    order['title'],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price: Rs. ${order['price']}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      Text(
                        'Status: ${order['orderStatus']}',
                        style: TextStyle(
                          color: order['orderStatus'] == 'pending'
                              ? Colors.orange
                              : Colors.greenAccent,
                        ),
                      ),
                    ],
                  ),
                  trailing:
                      const Icon(Icons.chevron_right, color: Colors.white),
                  onTap: () {
                    // Optional: Add a detailed order screen if needed
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
