import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/common/widget/riverpod_dialog.dart';
import 'package:tagit_frontend/modules/management/tag/interactive_tag_list.dart';

import '../../model/object/saved_file.dart';
import '../management/file/delete_dialog.dart';
import '../management/file/rename_dialog.dart';

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

void openDeleteFileDialog(
    BuildContext context, WidgetRef ref, SavedFileState savedFile) {
  showRiverpodDialog(context: context, child: DeleteFileDialog(savedFile));
}

void openRenameFileDialog(BuildContext context, SavedFileState savedFile) {
  showRiverpodDialog(context: context, child: FileRenameDialog(savedFile));
}
