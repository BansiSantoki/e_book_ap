import 'package:flutter/material.dart';

class SuccessBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: const BoxDecoration(
        color: Color(0xFFAF0606),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.check_circle,
                color: Color(0xFFAF0606),
                size: 60,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Successful",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
