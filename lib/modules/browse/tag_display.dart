import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/widgets/bordered_text.dart';
import '../../common/widgets/tile_bar_corners.dart';
import '../../model/object/child_tag.dart';
import '../../model/object/tag_counts.dart';
import 'screen/browser_model.dart';

class TagDisplay extends ConsumerWidget {
  final ChildTagState tag;

  const TagDisplay(this.tag, {super.key});

  Widget tagCounts(TagCounts counts) {
    final fileString = counts.files == counts.totalFiles
        ? counts.files
        : "${counts.files} (${counts.totalFiles})";
    final tagString = counts.tags == counts.totalTags
        ? counts.tags
        : "${counts.tags} (${counts.totalTags})";
    return Tooltip(
      message: "${counts.files} direct files\n"
          "${counts.totalFiles} total files\n"
          "${counts.tags} direct subtags\n"
          "${counts.totalTags} total subtags",
      child:
          BorderedText("$fileString / $tagString", overflow: TextOverflow.fade),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
        onTap: () => openTagBrowser(context, tag.fullName()),
        child: GridTile(
          header: GridTileBarCorners(trailing: tagCounts(tag.counts)),
          footer: GridTileBarCorners(
            leading: Tooltip(
                message: tag.name,
                child: BorderedText(tag.name, overflow: TextOverflow.fade)),
          ),
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Icon(
              Icons.sell,
              size: min(constraints.maxWidth, constraints.maxHeight),
              color: Colors.white30,
            );
          }),
        ));
  }
}
