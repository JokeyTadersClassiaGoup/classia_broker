import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

void showWarningToast({required String msg, Color? color}) {
  showToast(
    msg,
    position: ToastPosition.bottom,
    radius: 30,
    textPadding: const EdgeInsets.all(10.0),
    margin: const EdgeInsets.all(20),
    duration: const Duration(seconds: 7),
    textStyle: const TextStyle(
      fontSize: 14,
      color: Colors.white,
    ),
    backgroundColor: color ?? Colors.grey[700],
  );
}