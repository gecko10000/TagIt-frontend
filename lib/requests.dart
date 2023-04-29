import 'dart:convert';

import 'package:http/http.dart';
import 'package:tagit_frontend/screens/search.dart';

import 'misc/order.dart';
import 'objects/common.dart';
import 'objects/saved_file.dart';
import 'objects/tag.dart';

class RequestException implements Exception {
  final String message;
  const RequestException(this.message);
}

class APIClient extends BaseClient {
  final Client _client;
  APIClient(this._client);

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    StreamedResponse response = await _client.send(request);
    // response code not 2XX
    if (response.statusCode != 422 && response.statusCode ~/ 100 != 2) {
      throw RequestException("${response.statusCode}: ${await response.stream.bytesToString()}");
    }
    return response;
  }
}

Client _client = APIClient(Client());

Uri url(String endpoint, {Map<String, dynamic>? queryParameters}) => Uri(
    scheme: 'http',
    host: "localhost",
    port: 10000,
    path: endpoint,
    queryParameters: queryParameters);

Future<List<Tileable>> retrieveChildren(String? parent) async {
  var response = await _client.get(
      url(parent == null ? "tag" : "tag/${Uri.encodeComponent(parent)}/list"));
  var map = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  List<Tileable> returned = [];
  returned.addAll((map["children"] as List).map((e) => Tag.fromJson(e)));
  List? files = map["files"];
  if (files != null) {
    returned.addAll(files.map((e) => SavedFile.fromJson(e)));
  }
  return returned;
}

Future<Tag> getTag(String name) async {
  final response = await _client.get(url("tag/${Uri.encodeComponent(name)}"));
  final map =
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  return Tag.fromJson(map);
}

Future<void> sendTagDeletion(Tag tag) async {
  await _client.delete(url("tag/${Uri.encodeComponent(tag.fullName())}"));
}

Future<void> sendTagRename(Tag tag, String newName) async {
  await _client.patch(url("tag/${Uri.encodeComponent(tag.fullName())}"),
      body: {"name": newName});
}

Future<List<SavedFile>> getAllFiles(
    {Order order = Order.dateModified, bool reversed = false}) async {
  final response = await _client.get(url("files/all"),
      headers: {"order": order.apiName, "reversed": reversed.toString()});
  final files = jsonDecode(utf8.decode(response.bodyBytes)) as List;
  return files.map((j) => SavedFile.fromJson(j)).toList();
}

Future<void> sendFileDeletion(SavedFile file) async {
  await _client.delete(url("file/${Uri.encodeComponent(file.name)}"));
}

Future<void> sendFileRename(SavedFile file, String newName) async {
  await _client.patch(url("file/${Uri.encodeComponent(file.name)}"),
      body: {"name": newName});
}

Future<List<SavedFile>> sendSearchQuery(String query) async {
  Response response =
      await _client.get(url("search", queryParameters: {"q": query}));
  final json = jsonDecode(utf8.decode(response.bodyBytes));
  if (response.statusCode == 422) {
    // TODO: find a better way to bubble the index up
    // `json` is an int here
    throw SearchFormatException(json);
  }
  List files = json["files"];
  return files.map((j) => SavedFile.fromJson(j)).toList();
}

Future<void> sendPatchTag(String file, String tag, bool add) async {
  await _client.patch(
      url("file/${Uri.encodeComponent(file)}/${add ? "add" : "remove"}"),
      body: {"tags": jsonEncode([tag]) });
}
