import 'package:flutter/material.dart';

class NotImplementedScreen extends StatelessWidget {
  const NotImplementedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
        child: Text(
      "Not implemented",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 32),
    ));
  }
}
