import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/enum/sort_order.dart';
import 'package:tagit_frontend/modules/management/file/saved_file_view_model.dart';
import 'package:tagit_frontend/modules/management/tag/tag_view_model.dart';

class SortingPopup extends ConsumerStatefulWidget {
  @override
  ConsumerState<SortingPopup> createState() => _SortingPopupState();
}

class _SortingPopupState extends ConsumerState<SortingPopup> {
  RadioListTile<TagOrder> tagButton(TagOrder order) {
    return RadioListTile(
        value: order,
        groupValue: ref.watch(tagOrderProvider),
        title: Text(order.displayName),
        onChanged: (v) =>
            ref.read(tagOrderProvider.notifier).state = v ?? TagOrder.TAG_NAME);
  }

  RadioListTile<FileOrder> fileButton(FileOrder order) {
    return RadioListTile(
        value: order,
        groupValue: ref.watch(fileOrderProvider),
        title: Text(order.displayName),
        onChanged: (v) => ref.read(fileOrderProvider.notifier).state =
            v ?? FileOrder.MODIFICATION_DATE);
  }

  @override
  Widget build(BuildContext context) {
    bool tagsReversed = ref.watch(tagReverseProvider);
    bool filesReversed = ref.watch(fileReverseProvider);
    // Of course, Center(child: Container) works with width
    // constraints but Container(alignment: center) doesn't.
    // Makes perfect sense!
    return Center(child: LayoutBuilder(
      builder: (context, constraints) {
        final width = min(500, constraints.maxWidth).toDouble();
        return SizedBox(
            width: width,
            child: Material(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 12),
                      const Text(
                        "Tag Sorting",
                        style: TextStyle(fontSize: 16),
                      ),
                      IconButton(
                          onPressed: () => ref
                              .read(tagReverseProvider.notifier)
                              .state = !tagsReversed,
                          icon: Icon(tagsReversed
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down))
                    ],
                  ),
                  ...TagOrder.values.map((e) => tagButton(e)).toList(),
                  Row(
                    children: [
                      const SizedBox(width: 12),
                      const Text(
                        "File Sorting",
                        style: TextStyle(fontSize: 16),
                      ),
                      IconButton(
                          onPressed: () => ref
                              .read(fileReverseProvider.notifier)
                              .state = !filesReversed,
                          icon: Icon(filesReversed
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down))
                    ],
                  ),
                  ...FileOrder.values.map((e) => fileButton(e)).toList(),
                ],
              ),
            ));
      },
    ));
  }
}
