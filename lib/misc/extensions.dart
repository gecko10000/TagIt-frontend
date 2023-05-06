import 'dart:math';

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

extension IntMethods on int {
  String smartS() => this == 1 ? "" : "s";
  String toByteUnits() {
    const prefixes = ["", "k", "M", "G", "T"];
    int i = 0;
    for (int copy = this; copy > 0; copy ~/= 1000) {
      i++;
    }
    // < 1000 means i is 1, < 1m means i is 2, etc.
    // base case, `this` == 0 and i would be -1
    // if someone gets i past 4, good for them
    // "yes sir, i categorize petabyte-large files sir,
    // please fix this issue where it's only displaying terabytes"
    i = max(0,  min(4, i - 1));
    return "${this ~/ pow(1000, i)} ${prefixes[i]}B";
  }
}
