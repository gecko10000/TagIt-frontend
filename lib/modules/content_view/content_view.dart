import 'package:flutter/material.dart';
import 'package:tagit_frontend/model/api/files.dart';
import 'package:tagit_frontend/model/enum/media_type.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/modules/content_view/content_view_model.dart';
import 'package:tagit_frontend/modules/content_view/viewers/video_viewer.dart';

import '../../common/widgets/bordered_text.dart';

class ContentViewer extends StatelessWidget {
  final SavedFile savedFile;

  const ContentViewer({required this.savedFile, super.key});

  Widget imageViewer(SavedFile savedFile) {
    return FittedBox(
      fit: BoxFit.contain,
      child: FileAPI.getImage(savedFile),
    );
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
    final numTags = savedFile.tags.length;
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
                child: BorderedText(
              savedFile.name,
              overflow: TextOverflow.ellipsis,
            )),
            TextButton.icon(
                onPressed: () => openSavedFileTags(context, savedFile),
                icon: const Icon(Icons.sell),
                label: Text(numTags.toString()))
          ]),
      Flexible(
          child: switch (savedFile.mediaType) {
        MediaType.IMAGE => imageViewer,
        MediaType.VIDEO => videoViewer,
        _ => otherViewer,
      }(savedFile)),
    ]);
  }
}
