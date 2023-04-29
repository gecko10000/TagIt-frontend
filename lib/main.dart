import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/screens/home_page.dart';

void main() {
  runApp(const TagIt());
}

class TagIt extends StatelessWidget {
  const TagIt({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: MaterialApp(
          //navigatorObservers: [browseObserver],
          debugShowCheckedModeBanner: false,
          title: "TagIt",
          theme: ThemeData(
            colorScheme: const ColorScheme.dark(primary: Colors.blue),
          ),
          home: const HomePage(),
        )
    );
  }
}
