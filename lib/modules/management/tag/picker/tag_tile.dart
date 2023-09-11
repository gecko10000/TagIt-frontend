import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/common/widget/bordered_grid_tile.dart';
import 'package:tagit_frontend/model/object/child_tag.dart';
import 'package:tagit_frontend/modules/management/tag/picker/tag_picker.dart';
import 'package:tagit_frontend/modules/management/tag/picker/tag_picker_model.dart';

import '../../../../common/widget/bordered_text.dart';
import '../../../../common/widget/tag_counts_display.dart';
import '../../../../common/widget/tile_bar_corners.dart';

class TagPickerTile extends ConsumerWidget {
  final TagPickerScreen currentPicker;
  final ChildTagState tag;

  const TagPickerTile(this.tag, {required this.currentPicker, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedFile = currentPicker.savedFile;
    // for already-selected tags.
    final disabled = savedFile.tags.contains(tag.fullName());
    return BorderedGridTile(
        child: InkWell(
            onTap: () => openTagPicker(context, tag.fullName(), currentPicker),
            child: GridTile(
              header:
                  GridTileBarCorners(trailing: TagCountsDisplay(tag.counts)),
              footer: GridTileBarCorners(
                leading: Tooltip(
                    message: tag.name,
                    child: BorderedText(tag.name, overflow: TextOverflow.fade)),
                trailing: Checkbox(
                    // we mark already-selected tags
                    value: disabled ||
                        ref.watch(pickedTagsProvider).contains(tag.fullName()),
                    // a null onChanged disables the checkbox
                    onChanged: disabled
                        ? null
                        : (checked) {
                            final notifier =
                                ref.read(pickedTagsProvider.notifier);
                            (checked!
                                ? notifier.addTag
                                : notifier.removeTag)(tag.fullName());
                          }),
              ),
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Icon(
                  Icons.sell,
                  size: min(constraints.maxWidth, constraints.maxHeight),
                  color: Colors.white30,
                );
              }),
            )));
  }
}
