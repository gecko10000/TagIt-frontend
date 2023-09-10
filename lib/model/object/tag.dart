import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tagit_frontend/model/object/child_tag.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';

import 'displayable.dart';

part 'tag.freezed.dart';

part 'tag.g.dart';

@freezed
class TagState with _$TagState {
  // required for custom methods
  const TagState._();

  const factory TagState({
    required String name,
    String? parent,
    @Default([]) List<ChildTagState> children,
    @Default([]) List<SavedFileState> files,
    required int totalFileCount,
  }) = _TagState;

  factory TagState.fromJson(Map<String, Object?> json) =>
      _$TagStateFromJson(json);

  String fullName() {
    return parent == null ? name : "$parent/$name";
  }

  List<Displayable> getDisplayables() {
    return [...children, ...files];
  }

  static String getParentName(String tagName) {
    final slashIndex = tagName.lastIndexOf('/');
    return slashIndex == -1 ? "" : tagName.substring(0, slashIndex);
  }

}
