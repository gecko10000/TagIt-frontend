import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/modules/browse/browser_model.dart';
import 'package:tagit_frontend/modules/management/tag/tag_view_model.dart';

import '../../../model/api/tags.dart';
import '../../../model/object/tag.dart';

Future<void> renameTag(
    BuildContext context, WidgetRef ref, TagState tag, String newName) async {
  final fullNewName =
      tag.parentName == null ? newName : "${tag.parentName}/$newName";
  final newTag = await TagAPI.rename(tag.uuid, fullNewName);
  ref.invalidate(tagProvider(tag.parentUUID));
  if (context.mounted) {
    Navigator.pop(context);
    popAndOpenTagBrowser(context, newTag.uuid, newTag.fullName(),
        stackPush: true);
  }
}
