import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/model/api/files.dart';
import 'package:tagit_frontend/modules/management/tag/tag_view_model.dart';
import 'package:uuid/uuid.dart';

import '../../../model/enum/sort_order.dart';
import '../../../model/object/saved_file.dart';

part 'saved_file_view_model.g.dart';

@riverpod
class SavedFile extends _$SavedFile {
  @override
  Future<SavedFileState> build(UuidValue uuid) => FileAPI.getInfo(
      uuid, ref.watch(tagOrderProvider), ref.watch(tagReverseProvider));
}

final fileOrderProvider = StateProvider((ref) => FileOrder.MODIFICATION_DATE);
final fileReverseProvider = StateProvider((ref) => true);
