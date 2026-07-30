import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showsuccessMessage(BuildContext context, String message) {
  Flushbar(
    message: message,
    duration: Duration(seconds: 3),
    flushbarPosition: FlushbarPosition.BOTTOM,
    backgroundColor: Color(0xFFAF0606),
    icon: Icon(
      Icons.check_circle,
      color: Colors.white,
    ),
  )..show(context);
}

void showerrorMessage(BuildContext context, String message) {
  Flushbar(
    message: message,
    duration: Duration(seconds: 3),
    flushbarPosition: FlushbarPosition.BOTTOM,
    backgroundColor: Colors.black,
    icon: Icon(
      Icons.info_outline,
      color: Colors.white,
    ),
  )..show(context);
}

void successMessage(String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 15.0,
  );
}

void errorMessage(String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 15.0,
  );
}
