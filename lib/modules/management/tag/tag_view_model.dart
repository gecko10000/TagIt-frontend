import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';

import '../../../model/api/tags.dart';
import '../../../model/object/tag.dart';

part 'tag_view_model.g.dart';

@riverpod
class Tag extends _$Tag {
  @override
  Future<TagState> build(String tagName) => TagAPI.get(tagName);
}

void invalidateTags(WidgetRef ref, SavedFileState savedFile) {
  for (final tag in savedFile.tags) {
    ref.invalidate(tagProvider(tag));
  }
}
