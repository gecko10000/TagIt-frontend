import 'package:flutter/material.dart';
import 'package:tagit_frontend/models/objects/saved_file.dart';

class ContentViewer extends StatelessWidget {
  final SavedFile savedFile;

  const ContentViewer({required this.savedFile, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      width: 10,
      height: 10,
      child: ColoredBox(color: Colors.green),
    ));
  }
}
