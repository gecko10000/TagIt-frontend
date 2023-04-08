import 'package:tagit_frontend/objects/saved_file.dart';

class Tag {
  final String name;
  final String? parent;
  final Set<String> children = {};
  final Set<String> files = {};

  factory Tag.fromJson(Map<String, dynamic> json) =>
      Tag(
          json["name"],
          parent: json["parent"],
          children: json["children"],
          files: json["files"]
      );
  Tag(this.name, {this.parent, List<String> children = const [], List<String> files = const []}) {
    this.children.addAll(children);
    this.files.addAll(files);
  }
}
