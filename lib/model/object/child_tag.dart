import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tagit_frontend/model/object/tag_counts.dart';

import 'displayable.dart';

part 'child_tag.freezed.dart';
part 'child_tag.g.dart';

@freezed
class ChildTagState with _$ChildTagState implements Displayable {
  const ChildTagState._();

  factory ChildTagState({
    required String name,
    String? parent,
    required TagCounts counts,
  }) = _ChildTagState;

  factory ChildTagState.fromJson(Map<String, Object?> json) =>
      _$ChildTagStateFromJson(json);

  String fullName() {
    return parent == null ? name : "$parent/$name";
  }
}
