import 'package:flutter/material.dart';
import 'package:tagit_frontend/requests.dart';

import '../objects/saved_file.dart';

Future<void> openContentView(BuildContext context, SavedFile file) async {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: ContentViewer(
          file: file,
        ),
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
    final link = url("file/${Uri.encodeComponent(file.name)}");
    switch (ContentType.getType(file.mimeType)) {
      case ContentType.image:
        return Image.network(link.toString());
      case ContentType.video:
        // https://pub.dev/packages/flutter_meedu_videoplayer
        return const Text("Video player not implemented yet");
      case ContentType.audio:
        // https://pub.dev/packages/audioplayers
        return const Text("Audio player not implemented yet");
      case ContentType.text:
        return const Text("Text viewer/editor not implemented yet");
      case ContentType.other:
        return const Material(
          child: Icon(Icons.file_copy, size: 100),
        );
    }
  }
}

enum ContentType {
  image,
  video,
  audio,
  text,
  other,
  ;

  static ContentType getType(String s) {
    for (ContentType type in ContentType.values.take(4)) {
      if (s.startsWith(type.name)) return type;
    }
    return other;
  }
}
