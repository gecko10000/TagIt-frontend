import 'package:flutter/cupertino.dart';
import 'package:tagit_frontend/screens/not_implemented.dart';

Map<String, Widget Function(BuildContext)> routing() {
  return {
    // placeholder destinations for now
    "/tags": (ctx) => const NotImplementedScreen(),
    "/search": (ctx) => const NotImplementedScreen(),
  };
}
