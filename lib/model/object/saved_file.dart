import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tagit_frontend/model/enum/media_type.dart';
import 'package:tagit_frontend/model/object/dimensions.dart';
import 'package:tagit_frontend/model/object/uuid_converter.dart';
import 'package:uuid/uuid.dart';

import 'child_tag.dart';
import 'displayable.dart';

part 'saved_file.freezed.dart';
part 'saved_file.g.dart';

@freezed
class SavedFileState with _$SavedFileState implements Displayable {
  const factory SavedFileState({
    @UuidConverter() required UuidValue uuid,
    required String name,
    required MediaType mediaType,
    required int modificationDate,
    required int fileSize,
    required bool thumbnail,
    required Dimensions? dimensions,
    required List<ChildTagState> tags,
  }) = _SavedFileState;

  factory SavedFileState.fromJson(Map<String, Object?> json) =>
      _$SavedFileStateFromJson(json);
}
