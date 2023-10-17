import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/api/tags.dart';
import 'package:tagit_frontend/model/object/tag.dart';
import 'package:tagit_frontend/modules/management/tag/tag_view_model.dart';

void createTag(BuildContext context, WidgetRef ref, TagState parentTag,
    String tagName) async {
  final parentName = parentTag.fullName();
  final fullName = parentName.isEmpty ? tagName : "$parentName/$tagName";
  await TagAPI.create(fullName);
  ref.invalidate(tagProvider(parentName.isEmpty ? null : parentTag.uuid));
  if (context.mounted) Navigator.pop(context);
}
