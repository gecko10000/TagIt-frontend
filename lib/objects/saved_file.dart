import 'package:tagit_frontend/objects/tag.dart';

class SavedFile {
  final String name;
  final Set<Tag> tags = {};

  factory SavedFile.fromJson(Map<String, dynamic> json) =>
      SavedFile(
        json["name"],
        tags: json["tags"]
      );

  SavedFile(this.name, {List<Tag> tags = const []}) {
    this.tags.addAll(tags);
  }
}
