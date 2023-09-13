import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/api/files.dart';
import 'package:tagit_frontend/model/api/tags.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/model/object/tag.dart';
import 'package:tagit_frontend/modules/management/tag/tag_view_model.dart';

import '../../model/object/displayable.dart';

// note: for tags, this gives us the last part of the name.
// therefore, we need to join it with the rest of the name.
void renameDisplayable(BuildContext context, WidgetRef ref,
    Displayable displayable, String newName) async {
  Navigator.pop(context);
  if (displayable is SavedFileState) {
    await FileAPI.rename(displayable.name, newName);
    invalidateTags(ref, displayable);
    return;
  }
  // no auto cast :(
  final tag = displayable as TagState;
  final fullNewName = tag.parent == null ? newName : "${tag.parent}/$newName";
  await TagAPI.rename(tag.fullName(), fullNewName);
}
