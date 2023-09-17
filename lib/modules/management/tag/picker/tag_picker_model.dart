import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/model/object/child_tag.dart';
import 'package:tagit_frontend/modules/management/tag/picker/tag_picker.dart';
import 'package:uuid/uuid.dart';

import '../interactive_tag_list.dart';

part 'tag_picker_model.g.dart';

@riverpod
class PickedTags extends _$PickedTags {
  @override
  List<ChildTagState> build() => [];

  void addTag(ChildTagState tagId) => state = [...state, tagId];

  void removeTag(ChildTagState tagId) =>
      state = state.where((t) => t != tagId).toList();
}

void openTagPicker(
    BuildContext context, UuidValue tagId, TagPickerScreen parent) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => TagPickerScreen(
      tagId: tagId,
      savedFile: parent.savedFile,
      onPicked: parent.onPicked,
    ),
  ));
}

void closeTagPicker(BuildContext context) {
  Navigator.popUntil(context, (r) => r.settings.name == fileTagListRouteName);
}
