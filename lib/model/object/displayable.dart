import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/model/object/tag.dart';

part 'displayable.freezed.dart';

@freezed
class Displayable with _$Displayable {
  const factory Displayable.tag(Tag tag) = _Tag;

  const factory Displayable.file(SavedFile savedFile) = _SavedFile;
}
