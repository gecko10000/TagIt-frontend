import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/common/widget/bordered_text.dart';
import 'package:tagit_frontend/model/api/files.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';

import '../../common/widget/tile_bar_corners.dart';
import '../../model/enum/media_type.dart';
import 'browser_model.dart';

class FileTile extends ConsumerWidget {
  final SavedFileState savedFile;

  const FileTile(this.savedFile, {super.key});

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
    final numTags = savedFile.tags.length;
    return InkWell(
        onTap: () => openContentView(context, savedFile),
        child: GridTile(
          header: GridTileBarCorners(
              trailing: Tooltip(
                  message: "$numTags tags", child: BorderedText("$numTags"))),
          footer: tileFooter(),
          child: displayIcon(),
        ));
  }
}
