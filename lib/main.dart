import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tagit_frontend/screens/authenticate.dart';
import 'package:tagit_frontend/screens/home_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("settings");
  // accounts will store username, token, and endpoint
  await Hive.openBox("account");
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
        colorScheme: ColorScheme.dark(
            primary: Colors.blue, secondary: Colors.blue.withOpacity(0.7)),
      ),
      home: ValueListenableBuilder<Box>(
        valueListenable: Hive.box("account").listenable(),
        builder: (context, box, widget) =>
            box.get("token") == null ? const AuthScreen() : const HomePage(),
      ),
    ));
  }
}
