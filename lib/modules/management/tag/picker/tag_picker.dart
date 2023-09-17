import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/modules/browse/grid.dart';
import 'package:tagit_frontend/modules/management/tag/picker/tag_picker_model.dart';
import 'package:tagit_frontend/modules/management/tag/picker/tag_tile.dart';
import 'package:uuid/uuid.dart';

import '../../../../model/object/child_tag.dart';
import '../tag_view_model.dart';

class TagPickerScreen extends ConsumerWidget {
  final void Function(Iterable<UuidValue>)? onPicked;
  final SavedFileState savedFile;
  final UuidValue? tagId;

  const TagPickerScreen(
      {required this.tagId, required this.savedFile, this.onPicked, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tag = ref.watch(tagProvider(tagId));
    final displayables = tag.whenData((tag) => tag.children);
    final leadingIcon = tagId == null
        ? null
        : IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_upward));
    final pickedTags = ref.watch(pickedTagsProvider);
    return Scaffold(
        appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(tagId == null
                ? "Select Tags"
                : tag.when(
                    data: (t) => t.fullName(),
                    error: (ex, st) => "Error",
                    loading: () => "...")),
            Tooltip(
              message: pickedTags.map((t) => t.fullName()).join("\n"),
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
                    onPicked!(ref.read(pickedTagsProvider).map((t) => t.uuid));
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
