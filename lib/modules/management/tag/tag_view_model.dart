import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/model/enum/sort_order.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/modules/management/file/saved_file_view_model.dart';
import 'package:uuid/uuid.dart';

import '../../../model/api/tags.dart';
import '../../../model/object/tag.dart';

part 'tag_view_model.g.dart';

@riverpod
class Tag extends _$Tag {
  @override
  Future<TagState> build(UuidValue? uuid) => TagAPI.get(
      uuid,
      ref.watch(tagOrderProvider),
      ref.watch(tagReverseProvider),
      ref.watch(fileOrderProvider),
      ref.watch(fileReverseProvider));
}

final tagOrderProvider = StateProvider((ref) => TagOrder.TAG_NAME);
final tagReverseProvider = StateProvider((ref) => false);

void invalidateTags(WidgetRef ref, SavedFileState savedFile) {
  for (final tag in savedFile.tags) {
    ref.read(tagOrderProvider.notifier).state = TagOrder.NUM_FILES;
    ref.invalidate(tagProvider(tag.uuid));
  }
}
