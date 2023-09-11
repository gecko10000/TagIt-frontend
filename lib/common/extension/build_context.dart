import 'package:flutter/material.dart';

extension MyBuildContext on BuildContext {
  void showSnackBar(Widget content) {
    final snackBar = SnackBar(content: content);
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }

  void showTextSnackBar(String string) {
    showSnackBar(Text(string));
  }
}
