import 'package:freezed_annotation/freezed_annotation.dart';

@freezed
class ChildTag with _$ChildTag {
  factory ChildTag({
    required String name,
    required int tagCount,
    required int totalFileCount,
  }) = _ChildTag;
}
