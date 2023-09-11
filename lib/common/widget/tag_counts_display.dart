import 'package:flutter/material.dart';
import 'package:tagit_frontend/model/object/tag_counts.dart';

import 'bordered_text.dart';

class TagCountsDisplay extends StatelessWidget {
  final TagCounts counts;

  const TagCountsDisplay(this.counts, {super.key});

  @override
  Widget build(BuildContext context) {
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
}
