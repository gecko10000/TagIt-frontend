import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/common/widgets/bordered_text.dart';
import 'package:tagit_frontend/common/widgets/tile_bar_corners.dart';
import 'package:tagit_frontend/model/api/files.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';

import '../../model/enum/media_type.dart';
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
              color: Colors.white30,
            );
          });
  }

  Widget? tileFooter() {
    bool isVideo = savedFile.mediaType == MediaType.VIDEO;
    final leading = BorderedText(savedFile.name, overflow: TextOverflow.fade);
    final trailing = isVideo ? const Icon(Icons.play_arrow_rounded) : null;
    return GridTileBarCorners(
      leading: leading,
      trailing: trailing,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
        onTap: () => openFile(context, savedFile),
        child: GridTile(
          footer: tileFooter(),
          child: displayIcon(),
        ));
  }
}
