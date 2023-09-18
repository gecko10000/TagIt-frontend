import 'package:flutter/material.dart';
import 'package:tagit_frontend/common/widget/riverpod_dialog.dart';
import 'package:tagit_frontend/modules/management/rename_dialog.dart';
import 'package:tagit_frontend/modules/management/tag/interactive_tag_list.dart';

import '../../model/object/saved_file.dart';

void openSavedFileTags(BuildContext context, SavedFileState savedFile) {
  showRiverpodDialog(
    routeSettings: const RouteSettings(name: fileTagListRouteName),
    context: context,
    barrierDismissible: true,
    // note: we use the ID because it uses
    // a separate provider for the file info
    child: InteractiveTagList(savedFile.uuid),
  );
}

void renameFile(BuildContext context, SavedFileState savedFile) {
  showRiverpodDialog(context: context, child: RenameDialog(savedFile));
}
