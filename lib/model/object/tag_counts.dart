import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag_counts.freezed.dart';
part 'tag_counts.g.dart';

@freezed
class TagCounts with _$TagCounts {
  const factory TagCounts({
    required int tags,
    required int totalTags,
    required int files,
    required int totalFiles,
  }) = _TagCounts;

  factory TagCounts.fromJson(Map<String, Object?> json) =>
      _$TagCountsFromJson(json);
}
