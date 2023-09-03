import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tagit_frontend/model/object/tag_counts.dart';

import 'displayable.dart';

part 'child_tag.freezed.dart';
part 'child_tag.g.dart';

@freezed
class ChildTag with _$ChildTag implements Displayable {
  factory ChildTag({
    required String name,
    required TagCounts counts,
  }) = _ChildTag;

  factory ChildTag.fromJson(Map<String, Object?> json) =>
      _$ChildTagFromJson(json);
}
