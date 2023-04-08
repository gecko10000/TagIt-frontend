import 'package:flutter/material.dart';
import 'package:tagit_frontend/routing.dart';
import 'package:tagit_frontend/widgets/home.dart';

void main() {
  runApp(const TagIt());
}

class TagIt extends StatelessWidget {
  const TagIt({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TagIt",
      theme: ThemeData(
        colorScheme: const ColorScheme.dark()
      ),
      home: const HomeScreen(),
      routes: routing(),
    );
  }
}
