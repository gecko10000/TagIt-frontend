import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tagit_frontend/model/enum/media_type.dart';
import 'package:tagit_frontend/model/object/dimensions.dart';

import 'displayable.dart';

part 'saved_file.freezed.dart';
part 'saved_file.g.dart';

@freezed
class SavedFile with _$SavedFile implements Displayable {
  const factory SavedFile({
    required String name,
    required MediaType mediaType,
    required int modificationDate,
    required int fileSize,
    required String? thumbnail,
    required Dimensions? dimensions,
    required Set<String> tags,
  }) = _SavedFile;

  factory SavedFile.fromJson(Map<String, Object?> json) =>
      _$SavedFileFromJson(json);
}
