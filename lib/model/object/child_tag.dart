import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tagit_frontend/model/object/tag_counts.dart';
import 'package:tagit_frontend/model/object/uuid_converter.dart';
import 'package:uuid/uuid.dart';

import 'displayable.dart';

part 'child_tag.freezed.dart';
part 'child_tag.g.dart';

@freezed
class ChildTagState with _$ChildTagState implements Displayable {
  const ChildTagState._();

  factory ChildTagState({
    @UuidConverter() required UuidValue uuid,
    required String name,
    @UuidConverter() UuidValue? parentUUID,
    String? parentName,
    required TagCounts counts,
  }) = _ChildTagState;

  factory ChildTagState.fromJson(Map<String, Object?> json) =>
      _$ChildTagStateFromJson(json);

  String fullName() {
    return parentName == null ? name : "$parentName/$name";
  }
}
