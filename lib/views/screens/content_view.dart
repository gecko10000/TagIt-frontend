import 'package:flutter/material.dart';
import 'package:tagit_frontend/models/api/files.dart';
import 'package:tagit_frontend/models/file_type.dart';
import 'package:tagit_frontend/models/objects/saved_file.dart';
import 'package:tagit_frontend/views/widgets/content_viewers/video_viewer.dart';

class ContentViewer extends StatelessWidget {
  final SavedFile savedFile;

  const ContentViewer({required this.savedFile, super.key});

  Widget imageViewer(SavedFile savedFile) {
    return FileAPI.getImage(savedFile);
  }

  Widget videoViewer(SavedFile savedFile) {
    return VideoViewer(savedFile: savedFile);
  }

  Widget otherViewer(SavedFile savedFile) {
    return const SizedBox(
      height: 10,
      width: 10,
      child: ColoredBox(color: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget viewer = switch (ContentType.getType(savedFile)) {
      ContentType.image => imageViewer,
      ContentType.video => videoViewer,
      _ => otherViewer,
    }(savedFile);
    return Center(child: viewer);
  }
}
