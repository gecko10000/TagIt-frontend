import 'package:flutter/material.dart';

extension StringMethods on String {
  String toTitleCase() {
    final output = StringBuffer();
    bool wasSpace = true;
    for (int i = 0; i < length; i++) {
      output.write((wasSpace ? this[i].toUpperCase : this[i].toLowerCase)());
      wasSpace = this[i] == ' ';
    }
    return output.toString();
  }
}

extension BuildContextMethods on BuildContext {
  void showSnackBar(String text) {
    SnackBar bar = SnackBar(
        content: Text(text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      backgroundColor: Colors.black,
    );
    ScaffoldMessenger.of(this).showSnackBar(bar);
  }
}
