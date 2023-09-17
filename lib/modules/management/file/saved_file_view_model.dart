import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/model/api/files.dart';
import 'package:uuid/uuid.dart';

import '../../../model/object/saved_file.dart';

part 'saved_file_view_model.g.dart';

@riverpod
class SavedFile extends _$SavedFile {
  @override
  Future<SavedFileState> build(UuidValue uuid) => FileAPI.getInfo(uuid);
}
