import 'package:flutter/material.dart';

class PrimaryTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String labelText;
  final bool? obscureText;
  final FocusNode? nextFocusNode;
  final Widget? suffixIcon;
  final int? minLine;
  final bool? readOnly;
  final TextInputType? keyboardType;
  const PrimaryTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText,
    this.focusNode,
    this.nextFocusNode,
    this.suffixIcon,
    this.minLine,
    this.readOnly = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        readOnly: readOnly!,
        minLines: minLine,
        maxLines: null,
        expands: false,
        style: const TextStyle(fontSize: 18.0, color: Colors.white),
        controller: controller,
        textCapitalization: TextCapitalization.words,
        focusNode: focusNode,
        keyboardType: TextInputType.name,
        onEditingComplete: () {
          FocusScope.of(context).requestFocus(nextFocusNode);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10)),
          labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.9),
          ),
          labelText: labelText,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
