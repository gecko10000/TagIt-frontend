import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';

import '../browser/browser_model.dart';

class FileDisplay extends ConsumerWidget {
  final SavedFile savedFile;

  const FileDisplay(this.savedFile, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
        onTap: () => openFile(context, savedFile),
        child: GridTile(
          footer: Center(child: Text(savedFile.name)),
          child: const Icon(
            Icons.file_copy,
            size: 100,
          ),
        ));
  }
}
