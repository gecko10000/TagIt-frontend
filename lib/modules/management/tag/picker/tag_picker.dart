import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/modules/browse/grid.dart';
import 'package:tagit_frontend/modules/management/tag/picker/tag_picker_model.dart';
import 'package:tagit_frontend/modules/management/tag/picker/tag_tile.dart';

import '../../../../model/object/child_tag.dart';
import '../tag_view_model.dart';

class TagPickerScreen extends ConsumerWidget {
  final void Function(WidgetRef, List<String>)? onPicked;
  final SavedFileState savedFile;
  final String tagName;

  const TagPickerScreen(
      {required this.tagName,
      required this.savedFile,
      this.onPicked,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayables =
        ref.watch(tagProvider(tagName)).whenData((tag) => tag.children);
    final leadingIcon = tagName == ""
        ? null
        : IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_upward));
    final pickedTags = ref.watch(pickedTagsProvider);
    return Scaffold(
        appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(tagName == "" ? "Select Tags" : tagName),
            Tooltip(
              message: pickedTags.join("\n"),
              child: Text("${pickedTags.length} tags selected"),
            ),
          ]),
          automaticallyImplyLeading: false,
          leading: leadingIcon,
          actions: [
            IconButton(
                tooltip: "Confirm",
                onPressed: () {
                  if (onPicked != null) {
                    onPicked!(ref, ref.read(pickedTagsProvider));
                  }
                  //ref.invalidate(pickedTagsProvider);
                  closeTagPicker(context);
                },
                icon: const Icon(Icons.check)),
            IconButton(
                tooltip: "Cancel",
                onPressed: () => closeTagPicker(context),
                icon: const Icon(Icons.close))
          ],
        ),
        body: DisplayableGrid(
          displayables: displayables,
          itemBuilder: (context, displayable) =>
              TagPickerTile(displayable as ChildTagState, currentPicker: this),
        ));
  }
}
