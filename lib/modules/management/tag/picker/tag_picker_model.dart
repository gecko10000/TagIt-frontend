import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/modules/management/tag/picker/tag_picker.dart';

import '../interactive_tag_list.dart';

part 'tag_picker_model.g.dart';

@riverpod
class PickedTags extends _$PickedTags {
  @override
  List<String> build() => [];

  void addTag(String tagName) => state = [...state, tagName];

  void removeTag(String tagName) =>
      state = state.where((t) => t != tagName).toList();
}

void openTagPicker(
    BuildContext context, String tagName, TagPickerScreen parent) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => TagPickerScreen(
      tagName: tagName,
      savedFile: parent.savedFile,
      onPicked: parent.onPicked,
    ),
  ));
}

void closeTagPicker(BuildContext context) {
  Navigator.popUntil(context, (r) => r.settings.name == fileTagListRouteName);
}
