import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/api/files.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/modules/management/file/saved_file_view_model.dart';
import 'package:tagit_frontend/modules/management/tag/picker/tag_picker.dart';
import 'package:tagit_frontend/modules/management/tag/tag_view_model.dart';
import 'package:uuid/uuid.dart';

void addTags(BuildContext context, WidgetRef ref, SavedFileState savedFile) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TagPickerScreen(
            tagId: null,
            savedFile: savedFile,
            onPicked: (tags) async {
              final originalTags = savedFile.tags.map((t) => t.uuid);
              final futures = [
                for (final tag in tags) FileAPI.addTag(savedFile.uuid, tag)
              ];
              for (final future in futures) {
                await future;
              }
              for (final tag in [...tags, ...originalTags]) {
                ref.invalidate(tagProvider(tag));
              }
              ref.invalidate(savedFileProvider(savedFile.uuid));
            },
          )));
}

void removeTag(BuildContext context, WidgetRef ref, SavedFileState savedFile,
    UuidValue tagId) async {
  await FileAPI.removeTag(savedFile.uuid, tagId);
  invalidateTags(ref, savedFile);
  ref.invalidate(savedFileProvider(savedFile.uuid));
}
