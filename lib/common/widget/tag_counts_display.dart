import 'package:flutter/material.dart';
import 'package:tagit_frontend/model/object/tag_counts.dart';

import 'bordered_text.dart';

class TagCountsDisplay extends StatelessWidget {
  final TagCounts counts;

  const TagCountsDisplay(this.counts, {super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "${counts.files} direct files\n"
          "${counts.totalFiles} total files\n"
          "${counts.tags} direct subtags\n"
          "${counts.totalTags} total subtags",
      child: BorderedText("${counts.files} / ${counts.tags}",
          overflow: TextOverflow.fade),
    );
  }
}
