import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/api/files.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';

import '../browser/browser_model.dart';

class FileDisplay extends ConsumerWidget {
  final SavedFile savedFile;

  const FileDisplay(this.savedFile, {super.key});

  Widget displayIcon() {
    return savedFile.thumbnail
        ? FileAPI.getThumbnail(savedFile)
        : LayoutBuilder(builder: (context, constraints) {
            return Icon(
              Icons.file_copy,
              size: min(constraints.maxWidth, constraints.maxHeight),
              color: Colors.grey,
            );
          });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
        onTap: () => openFile(context, savedFile),
        child: GridTile(
          footer: Center(
              child: Text(
            savedFile.name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(backgroundColor: Colors.black.withOpacity(0.9)),
          )),
          child: displayIcon(),
        ));
  }
}
