import 'package:tagit_frontend/objects/saved_file.dart';

class Tag {
  final String name;
  final Tag? parent;
  final Set<Tag> children = {};
  final Set<SavedFile> files = {};

  factory Tag.fromJson(Map<String, dynamic> json) =>
      Tag(
          json["name"],
          parent: json["parent"],
          children: json["children"],
          files: json["files"]
      );
  Tag(this.name, {this.parent, List<Tag> children = const [], List<SavedFile> files = const []}) {
    this.children.addAll(children);
    this.files.addAll(files);
  }
}
