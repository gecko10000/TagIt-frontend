import 'package:tagit_frontend/objects/tag.dart';

class SavedFile {
  final String name;
  final Set<String> tags = {};

  factory SavedFile.fromJson(Map<String, dynamic> json) {
    return
      SavedFile(
          json["name"],
          tags: (json["tags"] as List).map((e) => e as String).toList()
      );
  }

  SavedFile(this.name, {List<String> tags = const []}) {
    this.tags.addAll(tags);
  }
}
