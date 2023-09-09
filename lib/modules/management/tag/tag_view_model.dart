import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/modules/management/tag/saved_file_view_model.dart';

import '../../../model/api/tags.dart';
import '../../../model/object/tag.dart';

part 'tag_view_model.g.dart';

@riverpod
class Tag extends _$Tag {
  @override
  Future<TagState> build(String tagName) async {
    final tag = await TagAPI.get(tagName);
    for (final file in tag.files) {
      ref.read(savedFileProvider(file.name).notifier).setValue(file);
    }
    return tag;
  }
}
