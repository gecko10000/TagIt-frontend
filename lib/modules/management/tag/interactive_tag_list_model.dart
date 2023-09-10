import 'package:flutter/material.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/modules/management/tag/picker/tag_picker.dart';
import 'package:tagit_frontend/modules/management/tag/saved_file_view_model.dart';

void addTags(BuildContext context, SavedFileState savedFile) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TagPickerScreen(
            tagName: "",
            savedFile: savedFile,
            onPicked: (ref, tags) {
              for (final tag in tags) {
                ref
                    .read(savedFileProvider(savedFile.name).notifier)
                    .addTag(tag);
              }
            },
          )));
}
