import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/model/enum/sort_order.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:uuid/uuid.dart';

import '../../../model/api/tags.dart';
import '../../../model/object/tag.dart';

part 'tag_view_model.g.dart';

@riverpod
class Tag extends _$Tag {
  @override
  Future<TagState> build(UuidValue? uuid) => TagAPI.get(uuid);
}

final tagSortProvider = StateProvider((ref) => SortOrder.MODIFICATION_DATE);
final tagReverseProvider = StateProvider((ref) => true);

void invalidateTags(WidgetRef ref, SavedFileState savedFile) {
  for (final tag in savedFile.tags) {
    ref.invalidate(tagProvider(tag.uuid));
  }
}
