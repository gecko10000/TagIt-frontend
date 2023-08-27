import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag.freezed.dart';
part 'tag.g.dart';

@freezed
class Tag with _$Tag {
  // required for custom methods
  const Tag._();

  const factory Tag({
    required String name,
    required String? parent,
    @Default({}) Set<String> children,
    @Default({}) Set<String> files,
  }) = _Tag;

  factory Tag.fromJson(Map<String, Object?> json) => _$TagFromJson(json);

  String fullName() {
    return parent == null ? name : "$parent/$name";
  }
}
