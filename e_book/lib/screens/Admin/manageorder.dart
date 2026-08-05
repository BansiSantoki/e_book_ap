import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageOrdersPage extends StatefulWidget {
  @override
  _ManageOrdersPageState createState() => _ManageOrdersPageState();
}

class _ManageOrdersPageState extends State<ManageOrdersPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore
          .collection('orders')
          .doc(orderId)
          .update({'orderStatus': status});
    } catch (e) {
      print("Error updating status: $e");
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
    } catch (e) {
      print("Error deleting order: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Manage Orders",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: Color(0xFFAF0606),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: Colors.white));
          }

          if (snapshot.hasError) {
            return Center(
                child: Text("Something went wrong",
                    style: TextStyle(color: Colors.white)));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text("No orders available",
                    style: TextStyle(color: Colors.white)));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              return Card(
                color: Color(0xFF1E1E1E),
                margin: EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text(order['title'],
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product: ${order['title']}',
                          style: TextStyle(color: Colors.white70)),
                      Text('Price: Rs.${order['price']}',
                          style: TextStyle(color: Colors.white70)),
                      Text('Phone: ${order['phone']}',
                          style: TextStyle(color: Colors.white70)),
                      Text('Address: ${order['address']}',
                          style: TextStyle(color: Colors.white70)),
                      Text('Status: ${order['orderStatus']}',
                          style: TextStyle(color: Colors.green)),
                      Text('Ordered on: ${order['timestamp'].toDate()}',
                          style: TextStyle(color: Colors.white54)),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.yellowAccent),
                        onPressed: () {
                          _showUpdateStatusDialog(
                              order.id, order['orderStatus']);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          _showDeleteConfirmationDialog(order.id);
                        },
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

  void _showUpdateStatusDialog(String orderId, String currentStatus) {
    TextEditingController statusController =
        TextEditingController(text: currentStatus);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title:
            Text("Update Order Status", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: statusController,
          style: TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            labelText: "Status",
            labelStyle: TextStyle(color: Colors.white70),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white38),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFAF0606)),
            ),
          ),
        ),
        actions: [
          TextButton(
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFAF0606),
            ),
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              String newStatus = statusController.text.trim();
              if (newStatus.isNotEmpty) {
                await updateOrderStatus(orderId, newStatus);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(String orderId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text("Delete Order", style: TextStyle(color: Colors.white)),
        content: Text("Are you sure you want to delete this order?",
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFAF0606),
            ),
            child: Text(
              "Delete",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              await deleteOrder(orderId);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
