import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:media_kit/media_kit.dart';
import 'package:tagit_frontend/modules/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await Hive.initFlutter("tagit");
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
      theme: ThemeData.dark(),
      home: const Home(),
    ));
  }
}
