import 'package:freezed_annotation/freezed_annotation.dart';

part 'size.freezed.dart';
part 'size.g.dart';

@freezed
class JsonSize with _$JsonSize {
  const factory JsonSize({
    required int width,
    required int height,
  }) = _JsonSize;

  factory JsonSize.fromJson(Map<String, Object?> json) =>
      _$JsonSizeFromJson(json);
}
