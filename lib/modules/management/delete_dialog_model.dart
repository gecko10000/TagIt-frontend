import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/api/files.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/modules/management/file/saved_file_view_model.dart';
import 'package:tagit_frontend/modules/management/tag/tag_view_model.dart';
import 'package:tagit_frontend/modules/upload/upload_model.dart';

void deleteSavedFile(
    BuildContext context, WidgetRef ref, SavedFileState savedFile) async {
  await FileAPI.delete(savedFile.uuid);
  if (context.mounted) {
    Navigator.pop(context);
    Navigator.pop(context);
  }
  for (final tag in savedFile.tags) {
    ref.invalidate(tagProvider(tag.uuid));
  }
  ref.read(uploadsProvider.notifier).removeByUuid(savedFile.uuid);
  // Note: this is delayed because the Navigator.pop animations
  // are not instant and invalidating it immediately will show
  // the stacktrace in the content view as it's closing
  Future.delayed(const Duration(seconds: 3),
      () => ref.invalidate(savedFileProvider(savedFile.uuid)));
}
