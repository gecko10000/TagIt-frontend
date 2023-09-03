import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tagit_frontend/model/object/child_tag.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';

import 'displayable.dart';

part 'tag.freezed.dart';

part 'tag.g.dart';

@freezed
class Tag with _$Tag {
  // required for custom methods
  const Tag._();

  const factory Tag({
    required String name,
    String? parent,
    @Default({}) Set<ChildTag> children,
    @Default({}) Set<SavedFile> files,
    required int totalFileCount,
  }) = _Tag;

  factory Tag.fromJson(Map<String, Object?> json) => _$TagFromJson(json);

  String fullName() {
    return parent == null ? name : "$parent/$name";
  }

  List<Displayable> getDisplayables() {
    return [...children, ...files];
  }
}
