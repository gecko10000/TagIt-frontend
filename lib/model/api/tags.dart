import 'dart:convert';

import 'package:tagit_frontend/model/api/base.dart';

import '../object/tag.dart';

class TagAPI {
  TagAPI._();

  static Future<void> create(String name) async {
    await client.post(url("tag/${Uri.encodeComponent(name)}"));
  }

  static Future<TagState> get(String name) async {
    final endpoint = name == "" ? "tag" : "tag/${Uri.encodeComponent(name)}";
    final response = await client.get(url(endpoint));
    final map =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return TagState.fromJson(map);
  }

  static Future<void> rename(String currentName, String newName) async {
    await client.patch(url("tag/${Uri.encodeComponent(currentName)}"),
        body: {"name": newName});
  }

  static Future<void> delete(String fullName) async {
    await client.delete(url("tag/${Uri.encodeComponent(fullName)}"));
  }
}
