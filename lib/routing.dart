import 'package:flutter/cupertino.dart';
import 'package:tagit_frontend/screens/files.dart';

Map<String, Widget Function(BuildContext)> routing() {
  return {
    // placeholder destinations for now
    "/tags": (ctx) => const FileScreen(),
    "/search": (ctx) => const FileScreen(),
  };
}
