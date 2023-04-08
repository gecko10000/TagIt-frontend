import 'package:flutter/cupertino.dart';
import 'package:tagit_frontend/widgets/home.dart';

Map<String, Widget Function(BuildContext)> routing() {
  return {
    // placeholder destinations for now
    "/tags": (ctx) => const HomeScreen(),
    "/search": (ctx) => const HomeScreen(),
  };
}
