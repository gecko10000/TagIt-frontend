import 'package:dio/dio.dart';
import 'package:tagit_frontend/model/api/base.dart';
import 'package:tagit_frontend/model/enum/sort_order.dart';
import 'package:uuid/uuid.dart';

import '../object/tag.dart';

class TagAPI {
  TagAPI._();

  static Future<void> create(String name) async {
    await client.post("/tag/${Uri.encodeComponent(name)}");
  }

  static Future<TagState> get(UuidValue? tagId, TagOrder tagOrder,
      bool tagsReversed, FileOrder fileOrder, bool filesReversed) async {
    final endpoint = tagId == null ? "/tag" : "/tag/${tagId.uuid}";
    final response = await client.get(endpoint,
        options: Options(headers: {
          "tagOrder": tagOrder.name,
          "tagsReversed": tagsReversed,
          "fileOrder": fileOrder.name,
          "filesReversed": filesReversed
        }));
    return TagState.fromJson(response.data);
  }

  static Future<TagState> rename(UuidValue tagId, String newName) async {
    final response = await client.patch(
      "/tag/${tagId.uuid}",
      data: FormData.fromMap({"name": newName}),
    );
    return TagState.fromJson(response.data);
  }

  static Future<void> delete(UuidValue tagId) async {
    await client.delete("/tag/${tagId.uuid}");
  }
}
