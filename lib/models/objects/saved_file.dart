import 'package:freezed_annotation/freezed_annotation.dart';

import 'file_info.dart';

part 'saved_file.freezed.dart';
part 'saved_file.g.dart';

@freezed
class SavedFile with _$SavedFile {
  const factory SavedFile({
    @JsonKey(name: "fileInfo") required FileInfo info,
    required Set<String> tags,
  }) = _SavedFile;

  factory SavedFile.fromJson(Map<String, Object?> json) =>
      _$SavedFileFromJson(json);
}
