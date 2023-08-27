import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_info.freezed.dart';
part 'file_info.g.dart';

@freezed
class FileInfo with _$FileInfo {
  const factory FileInfo({
    required String name,
    required String mimeType,
    required int modificationTimeMillis,
    required int fileSizeBytes,
  }) = _FileInfo;

  factory FileInfo.fromJson(Map<String, Object?> json) =>
      _$FileInfoFromJson(json);
}
