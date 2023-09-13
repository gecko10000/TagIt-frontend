import 'package:flutter/material.dart';
import 'package:tagit_frontend/modules/management/rename_dialog.dart';
import 'package:tagit_frontend/modules/management/tag/interactive_tag_list.dart';

import '../../model/object/saved_file.dart';

void openSavedFileTags(BuildContext context, SavedFileState savedFile) {
  Navigator.pop(context);
  showDialog(
    routeSettings: const RouteSettings(name: fileTagListRouteName),
    context: context,
    barrierDismissible: true,
    builder: (context) {
      // note: we use the name because it uses
      // a separate provider for the file info
      return InteractiveTagList(savedFile);
    },
  );
}

void renameFile(BuildContext context, SavedFileState savedFile) {
  showDialog(context: context, builder: (context) => RenameDialog(savedFile));
}
