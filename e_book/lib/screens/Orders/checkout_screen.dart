import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book/config/messages.dart';
import 'package:e_book/models/bookitems.dart';
import 'package:e_book/screens/Orders/order_screen.dart';
import 'package:e_book/screens/Orders/success_bottom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_book/controllers/auth_controller.dart';

class CheckoutScreen extends StatefulWidget {
  final BookItem book;
  final int price;

  const CheckoutScreen({super.key, required this.book, required this.price});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  bool isPlacingOrder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFAF0606),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: const [
                  Icon(Icons.book, color: Colors.white70),
                  SizedBox(width: 8),
                  Text(
                    "Book Info",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Book Info
              Row(
                children: [
                  Image.network(
                    widget.book.coverImage,
                    height: 100,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.book.title,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Price
              Row(
                children: [
                  const Icon(Icons.attach_money, color: Colors.white70),
                  const SizedBox(width: 6),
                  Text(
                    "Price: Rs. ${widget.price}",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Address
              TextField(
                controller: addressController,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.location_on, color: Colors.white70),
                  labelText: "Delivery Address",
                  labelStyle:
                      const TextStyle(color: Colors.white70, fontSize: 16),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white38),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),

              // Phone Number
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.phone_android, color: Colors.white70),
                  labelText: "Phone Number",
                  labelStyle:
                      const TextStyle(color: Colors.white70, fontSize: 16),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white38),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Place Order Button
              isPlacingOrder
                  ? const CircularProgressIndicator(color: Colors.redAccent)
                  : ElevatedButton.icon(
                      onPressed: placeOrder,
                      icon: const Icon(Icons.shopping_cart_checkout,
                          color: Colors.white),
                      label: const Text(
                        'Place Order (Cash on Delivery)',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAF0606),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> placeOrder() async {
    if (addressController.text.isEmpty || phoneController.text.isEmpty) {
      showerrorMessage(Get.context!, 'Missing Info Please fill all fields.');
      return;
    }

    try {
      setState(() {
        isPlacingOrder = true;
      });

      final authController = Get.find<AuthController>();
      final userId = authController.auth.currentUser?.uid;

      await FirebaseFirestore.instance.collection('orders').add({
        "uid": userId,
        "title": widget.book.title,
        "cover": widget.book.coverImage,
        "price": widget.price,
        "address": addressController.text,
        "phone": phoneController.text,
        "orderStatus": "pending",
        "timestamp": FieldValue.serverTimestamp(),
      });

      setState(() {
        isPlacingOrder = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          content: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Color(0xFFAF0606),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 30),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Order placed successfully!',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      Get.to(() => OrdersScreen());
    } catch (e) {
      setState(() {
        isPlacingOrder = false;
      });
      print('Error placing order: $e');
      showerrorMessage(Get.context!, 'Error Failed to place order.');
    }
  }
}
