import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/model/api/files.dart';
import 'package:tagit_frontend/modules/management/tag/tag_view_model.dart';

import '../../../model/object/saved_file.dart';

part 'saved_file_view_model.g.dart';

@riverpod
class SavedFile extends _$SavedFile {
  @override
  Future<SavedFileState> build(String fileName) => FileAPI.getInfo(fileName);

  void setValue(SavedFileState savedFile) => state = AsyncData(savedFile);

  void removeTag(String tagName) {
    final savedFile = state.value;
    if (savedFile == null) return;
    FileAPI.removeTag(fileName, tagName);
    final newTags = savedFile.tags.where((t) => t != tagName).toList();
    setValue(savedFile.copyWith(tags: newTags));
    ref.invalidate(tagProvider(tagName));
  }

  Future<void> addTag(String tagName) async {
    final savedFile = state.value;
    if (savedFile == null) return;
    await FileAPI.addTag(fileName, tagName);
    final newTags = [...savedFile.tags, tagName];
    setValue(savedFile.copyWith(tags: newTags));
    ref.invalidate(tagProvider(tagName));
  }
}