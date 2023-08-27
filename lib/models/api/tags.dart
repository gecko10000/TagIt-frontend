import 'dart:convert';

import 'package:tagit_frontend/models/api/base.dart';

import '../objects/displayable.dart';
import '../objects/saved_file.dart';
import '../objects/tag.dart';

class TagAPI {

  static Future<void> create(String name) async {
    await client.post(url("tag/${Uri.encodeComponent(name)}"));
  }

  static Future<Tag> get(String name) async {
    final response = await client.get(url("tag/${Uri.encodeComponent(name)}"));
    final map =
    jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return Tag.fromJson(map);
  }

  static Future<List<Displayable>> getChildren(String? parent) async {
    var response = await client.get(url(
        parent == null ? "tag" : "tag/${Uri.encodeComponent(parent)}/list"));
    var map = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    List<Displayable> returned = [];
    returned.addAll(
        (map["children"] as List).map((e) => Displayable.tag(Tag.fromJson(e))));
    List? files = map["files"];
    if (files != null) {
      returned
          .addAll(files.map((e) => Displayable.file(SavedFile.fromJson(e))));
    }
    return returned;
  }

  static Future<void> rename(String currentName, String newName) async {
    await client.patch(url("tag/${Uri.encodeComponent(currentName)}"),
        body: {"name": newName});
  }

  static Future<void> delete(String fullName) async {
    await client.delete(url("tag/${Uri.encodeComponent(fullName)}"));
  }

}
