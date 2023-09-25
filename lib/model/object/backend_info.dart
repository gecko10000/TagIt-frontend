import 'package:freezed_annotation/freezed_annotation.dart';

part 'backend_info.freezed.dart';
part 'backend_info.g.dart';

@freezed
class BackendInfo with _$BackendInfo {
  factory BackendInfo({
    required String version,
    required int users,
  }) = _BackendInfo;

  factory BackendInfo.fromJson(Map<String, Object?> json) =>
      _$BackendInfoFromJson(json);
}
