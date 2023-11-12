import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/common/extension/int.dart';
import 'package:tagit_frontend/common/style/button_style.dart';
import 'package:tagit_frontend/model/api/files.dart';
import 'package:tagit_frontend/model/enum/media_type.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/modules/content_view/content_view_model.dart';
import 'package:tagit_frontend/modules/content_view/viewers/video_viewer.dart';
import 'package:tagit_frontend/modules/management/file/share.dart';
import 'package:uuid/uuid.dart';

import '../../common/widget/bordered_text.dart';
import '../management/file/download.dart';
import '../management/file/saved_file_view_model.dart';

class ContentViewer extends ConsumerWidget {
  final UuidValue fileId;

  const ContentViewer({required this.fileId, super.key});

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

  Widget topRow(BuildContext context, WidgetRef ref, SavedFileState savedFile) {
    final numTags = savedFile.tags.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(children: [
          Row(
            children: [
              Tooltip(
                  message: "Download file",
                  child: TextButton(
                    onPressed: () => downloadFile(context, savedFile),
                    style: defaultButtonStyle(),
                    child: const Icon(Icons.download),
                  )),
              Tooltip(
                  message: "Share file",
                  child: TextButton(
                      onPressed: () => shareFile(context, savedFile),
                      style: defaultButtonStyle(),
                      child: const Icon(Icons.share))),
            ],
          ),
          Text(savedFile.fileSize.readableFileSize())
        ]),
        Row(
          children: [
            Tooltip(
                message: "Manage tags",
                child: TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      openSavedFileTags(context, savedFile);
                    },
                    style: defaultButtonStyle(),
                    icon: const Icon(Icons.sell),
                    label: Text(numTags.toString()))),
            Tooltip(
                message: "Delete file",
                child: TextButton(
                    onPressed: () =>
                        openDeleteFileDialog(context, ref, savedFile),
                    style: defaultButtonStyle(),
                    child: const Icon(Icons.delete))),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(savedFileProvider(fileId)).when(
        data: (savedFile) => Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  topRow(context, ref, savedFile),
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
                              onPressed: () =>
                                  openRenameFileDialog(context, savedFile),
                              style: defaultButtonStyle(),
                              child: BorderedText(
                                savedFile.name,
                                overflow: TextOverflow.fade,
                                textAlign: TextAlign.right,
                              )))),
                ]),
        error: (ex, st) => Center(child: Text("$ex\n$st")),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
