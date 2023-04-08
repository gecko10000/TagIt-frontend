import 'package:flutter/material.dart';
import 'package:tagit_frontend/misc/colors.dart';
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
      debugShowCheckedModeBanner: false,
      title: "TagIt",
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(primary: Colors.blueAccent),
      ),
      home: const HomeScreen(),
      routes: routing(),
    );
  }
}
