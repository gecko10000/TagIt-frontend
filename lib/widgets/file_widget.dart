import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tagit_frontend/misc/colors.dart';
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
    return Container(
      padding: const EdgeInsets.all(5),
      child: ListTile(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          hoverColor: CustomColor.paynesGray,
          tileColor: CustomColor.paynesGray.withOpacity(0.9),
          title: Text(file.name),
          onTap: () => {}, // without an onTap, hoverColor does not work
      )

    );
  }
}
