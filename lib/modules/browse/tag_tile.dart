import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/widgets/bordered_text.dart';
import '../../common/widgets/tag_counts_display.dart';
import '../../common/widgets/tile_bar_corners.dart';
import '../../model/object/child_tag.dart';
import 'browser_model.dart';

class TagTile extends ConsumerWidget {
  final ChildTagState tag;

  const TagTile(this.tag, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
        onTap: () => openTagBrowser(context, tag.fullName()),
        child: GridTile(
          header: GridTileBarCorners(trailing: TagCountsDisplay(tag.counts)),
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