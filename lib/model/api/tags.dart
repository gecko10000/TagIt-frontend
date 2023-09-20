import 'package:dio/dio.dart';
import 'package:tagit_frontend/model/api/base.dart';
import 'package:uuid/uuid.dart';

import '../object/tag.dart';

class TagAPI {
  TagAPI._();

  static Future<void> create(String name) async {
    await client.post("/tag/${Uri.encodeComponent(name)}");
  }

  static Future<TagState> get(UuidValue? tagId) async {
    final endpoint = tagId == null ? "/tag" : "/tag/${tagId.uuid}";
    final response = await client.get(endpoint);
    return TagState.fromJson(response.data);
  }

  static Future<void> rename(UuidValue tagId, String newName) async {
    await client.patch("/tag/${tagId.uuid}",
        data: FormData.fromMap({"name": newName}),
        options: Options(responseType: ResponseType.plain));
  }

  static Future<void> delete(UuidValue tagId) async {
    await client.delete("/tag/${tagId.uuid}");
  }
}
