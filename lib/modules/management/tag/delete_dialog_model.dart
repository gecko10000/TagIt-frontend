import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/api/tags.dart';
import 'package:tagit_frontend/model/object/tag.dart';
import 'package:tagit_frontend/modules/management/tag/tag_view_model.dart';

void deleteTag(BuildContext context, WidgetRef ref, TagState tag) async {
  await TagAPI.delete(tag.uuid);
  ref.invalidate(tagProvider(tag.parentUUID));
  if (context.mounted) {
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
