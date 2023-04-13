import 'package:flutter/material.dart';
import 'package:tagit_frontend/screens/browser.dart';

void main() {
  runApp(const TagIt());
}

class TagIt extends StatelessWidget {
  const TagIt({super.key});

  static final RouteObserver browseObserver = RouteObserver<MaterialPageRoute>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [browseObserver],
      debugShowCheckedModeBanner: false,
      title: "TagIt",
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(primary: Colors.blueAccent),
      ),
      home: const BrowseScreen(),
    );
  }
}
