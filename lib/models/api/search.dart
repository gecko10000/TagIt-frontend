import 'dart:convert';

import 'package:http/http.dart';
import 'package:tagit_frontend/models/api/base.dart';

import '../objects/saved_file.dart';
import '../objects/tag.dart';

class SearchAPI {
  static Future<List<SavedFile>> fileSearch(String query) async {
    Response response =
        await client.get(url("search/all", queryParameters: {"q": query}));
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 422) {
      // TODO: find a better way to bubble the index up
      // `json` is an int here
      throw Exception(json);
    }
    return (json as List).map((j) => SavedFile.fromJson(j)).toList();
  }

  static Future<List<Tag>> sendTagSearch(String substring) async {
    Response response =
        await client.get(url("search/tags", queryParameters: {"q": substring}));
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    return (json as List).map((j) => Tag.fromJson(j)).toList();
  }
}
