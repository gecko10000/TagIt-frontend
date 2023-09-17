import 'dart:convert';

import 'package:tagit_frontend/model/api/base.dart';
import 'package:uuid/uuid.dart';

import '../object/tag.dart';

class TagAPI {
  TagAPI._();

  static Future<void> create(String name) async {
    await client.post(url("tag/${Uri.encodeComponent(name)}"));
  }

  static Future<TagState> get(UuidValue? tagId) async {
    final endpoint = tagId == null ? "tag" : "tag/${tagId.uuid}";
    final response = await client.get(url(endpoint));
    final map =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return TagState.fromJson(map);
  }

  static Future<void> rename(UuidValue tagId, String newName) async {
    await client.patch(url("tag/${tagId.uuid}"), body: {"name": newName});
  }

  static Future<void> delete(UuidValue tagId) async {
    await client.delete(url("tag/${tagId.uuid}"));
  }
}
