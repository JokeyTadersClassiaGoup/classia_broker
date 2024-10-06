import 'package:flutter/material.dart';

Widget commonText(String text) {
  return Align(
    alignment: Alignment.center,
    child: Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
}
