import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/object/child_tag.dart';
import '../../model/object/tag_counts.dart';
import '../browser/browser_model.dart';

class TagDisplay extends ConsumerWidget {
  final ChildTag tag;

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
      child: Text("$fileString / $tagString"),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
        onTap: () => openTag(context, tag),
        child: GridTile(
          header: GridTileBar(
              title: Align(
                  alignment: Alignment.centerRight,
                  child: tagCounts(tag.counts))),
          footer: GridTileBar(
              title: Align(
                  // the alignment ensures the tooltip is only shown when hovering directly over the text
                  alignment: Alignment.centerLeft,
                  child: Tooltip(
                      message: tag.name,
                      child: Text(
                        tag.name,
                        overflow: TextOverflow.fade,
                      )))),
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
