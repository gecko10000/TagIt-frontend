import 'package:flutter/material.dart';
import 'package:tagit_frontend/modules/management/tag/interactive_tag_list.dart';

import '../../model/object/saved_file.dart';

void openSavedFileTags(BuildContext context, SavedFileState savedFile) {
  Navigator.pop(context);
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      // note: we use the name because it uses
      // a separate provider for the file info
      return InteractiveTagList(savedFile.name);
    },
  );
}
