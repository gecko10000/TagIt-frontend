import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/modules/management/tag/picker/tag_picker.dart';
import 'package:tagit_frontend/modules/management/tag/saved_file_view_model.dart';
import 'package:tagit_frontend/modules/management/tag/tag_view_model.dart';

void addTags(BuildContext context, WidgetRef ref, SavedFileState savedFile) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TagPickerScreen(
            tagName: "",
            savedFile: savedFile,
            onPicked: (tags) async {
              final originalTags = savedFile.tags;
              final futures = [
                for (final tag in tags)
                  ref
                      .read(savedFileProvider(savedFile.name).notifier)
                      .addTag(tag)
              ];
              for (final future in futures) {
                await future;
              }
              ref.invalidate(savedFileProvider(savedFile.name));
              for (final tag in [...tags, ...originalTags]) {
                ref.invalidate(tagProvider(tag));
              }
            },
          )));
}
