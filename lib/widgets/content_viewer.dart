import 'package:flutter/material.dart';
import 'package:tagit_frontend/requests.dart';

import '../objects/saved_file.dart';

Future<void> openContentView(BuildContext context, SavedFile file) async {
  showDialog(
    context: context,
    builder: (context) {
      return ContentViewer(
        file: file,
      );
    },
    barrierDismissible: true,
  );
}

class ContentViewer extends StatelessWidget {
  final SavedFile file;
  const ContentViewer({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Center(child: file.name.endsWith(".png")
        ? Image.network(
            url("file/${Uri.encodeComponent(file.name)}").toString())
        : Text(file.name));
  }
}
