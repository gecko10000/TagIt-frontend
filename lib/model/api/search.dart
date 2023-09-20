import 'package:dio/dio.dart';
import 'package:tagit_frontend/model/api/base.dart';

import '../object/saved_file.dart';
import '../object/tag.dart';

class SearchAPI {
  SearchAPI._();

  static Future<List<SavedFileState>> fileSearch(String query) async {
    Response response =
        await client.get("/search/files", queryParameters: {"q": query});
    final json = response.data;
    if (response.statusCode == 422) {
      throw SearchFormatException(json["index"] ?? -1);
    }
    return (json as List).map((j) => SavedFileState.fromJson(j)).toList();
  }

  static Future<List<TagState>> tagSearch(String substring) async {
    Response response =
        await client.get("/search/tags", queryParameters: {"q": substring});
    return (response.data as List).map((j) => TagState.fromJson(j)).toList();
  }
}

class SearchFormatException implements Exception {
  final int index;

  const SearchFormatException(this.index);
}
