

class Tag {
  final String name;
  final String? parent;
  final Set<String> children = {};
  final Set<String> files = {};

  factory Tag.fromJson(Map<String, dynamic> json) =>
      Tag(
          json["name"],
          parent: json["parent"],
          children: (json["children"] as List).map((d) => d as String).toList(),
          files: (json["files"] as List).map((d) => d as String).toList()
      );
  Tag(this.name, {this.parent, List<String> children = const [], List<String> files = const []}) {
    this.children.addAll(children);
    this.files.addAll(files);
  }

  String fullName() => parent == null ? name : "$parent/$name";
}
