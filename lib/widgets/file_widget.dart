import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tagit_frontend/objects/saved_file.dart';

class FileTile extends StatelessWidget {
  FileTile({super.key, required this.file}) {
    random = Random(file.name.hashCode);
  }

  final SavedFile file;

  late final Random random;

  int _color() {
    return random.nextInt(255);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Color.fromRGBO(_color(), _color(), _color(), 0.3),
      title: Text(file.name),
    );
  }
}
