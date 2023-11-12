import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/modules/management/file/saved_file_view_model.dart';

import '../../../model/api/files.dart';
import '../../../model/object/saved_file.dart';
import '../tag/tag_view_model.dart';

void renameFile(BuildContext context, WidgetRef ref, SavedFileState savedFile,
    String newName) async {
  await FileAPI.rename(savedFile.uuid, newName);
  invalidateTags(ref, savedFile);
  ref.invalidate(savedFileProvider(savedFile.uuid));
  ref.invalidate(allFilesProvider);
  if (context.mounted) Navigator.pop(context);
  return;
  // no auto cast :(
}
