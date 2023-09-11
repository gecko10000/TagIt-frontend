import 'package:flutter/material.dart';
import 'package:tagit_frontend/model/api/files.dart';
import 'package:tagit_frontend/model/enum/media_type.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/modules/content_view/content_view_model.dart';
import 'package:tagit_frontend/modules/content_view/viewers/video_viewer.dart';

import '../../common/widgets/bordered_text.dart';

class ContentViewer extends StatelessWidget {
  final SavedFileState savedFile;

  const ContentViewer({required this.savedFile, super.key});

  Widget imageViewer(SavedFileState savedFile) {
    return FittedBox(
      fit: BoxFit.contain,
      child: FileAPI.getImage(savedFile),
    );
  }

  Widget videoViewer(SavedFileState savedFile) {
    return VideoViewer(savedFile: savedFile);
  }

  Widget otherViewer(SavedFileState savedFile) {
    return const SizedBox(
      height: 10,
      width: 10,
      child: ColoredBox(color: Colors.green),
    );
  }

  Widget topRow(BuildContext context) {
    final numTags = savedFile.tags.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Tooltip(
                message: "Download file",
                child: TextButton(
                  onPressed: () => print("Downloading file"),
                  child: const Icon(Icons.download),
                )),
            Tooltip(
                message: "Share file",
                child: TextButton(
                    onPressed: () => print("Sharing file"),
                    child: const Icon(Icons.share))),
          ],
        ),
        Row(
          children: [
            Tooltip(
                message: "Manage tags",
                child: TextButton.icon(
                    onPressed: () => openSavedFileTags(context, savedFile),
                    icon: const Icon(Icons.sell),
                    label: Text(numTags.toString()))),
            Tooltip(
                message: "Delete file",
                child: TextButton(
                    onPressed: () => print("Deleting file"),
                    child: const Icon(Icons.delete))),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      topRow(context),
      Flexible(
          child: switch (savedFile.mediaType) {
        MediaType.IMAGE => imageViewer,
        MediaType.VIDEO => videoViewer,
        _ => otherViewer,
      }(savedFile)),
      Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(5),
          child: Tooltip(
              message: "Rename file",
              child: TextButton(
                  onPressed: () => print("Renaming file"),
                  child: BorderedText(
                    savedFile.name,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.right,
                  )))),
    ]);
  }
}
