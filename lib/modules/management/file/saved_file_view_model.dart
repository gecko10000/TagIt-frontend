import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/model/api/files.dart';

import '../../../model/object/saved_file.dart';

part 'saved_file_view_model.g.dart';

@riverpod
class SavedFileByUUID extends _$SavedFileByUUID {
  @override
  Future<SavedFileState> build(String uuid) => FileAPI.getInfo(uuid);
}
