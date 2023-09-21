import 'package:flutter/material.dart';
import 'package:tagit_frontend/modules/home/home.dart';

extension MyBuildContext on BuildContext {
  void showSnackBar(Widget content) {
    final snackBar = SnackBar(
      content: content,
    );
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }

  void showTextSnackBar(String string) {
    showSnackBar(Text(string));
  }
}

// surely this is not intended usage
// TODO: uhhhh, not this
// https://stackoverflow.com/questions/58597980/flutter-looking-up-a-deactivated-widget-when-showing-snackbar-from-build-context#comment127253027_65820931
void showStaticSnackBar(Widget content) {
  homeContext.showSnackBar(content);
}
