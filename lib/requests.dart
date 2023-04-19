import 'dart:convert';

import 'package:http/http.dart';

import 'misc/order.dart';
import 'objects/saved_file.dart';
import 'objects/tag.dart';
import 'objects/tileable.dart';

class _APIClient extends BaseClient {

  final Client _client;

  _APIClient(this._client);

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    return _client.send(request);
  }

}

_APIClient _client = _APIClient(Client());

Uri url(String endpoint) => Uri(scheme: 'http', host: "localhost", port: 10000, path: endpoint);

Future<List<Tileable>> retrieveChildren(String? parent) async {
  var response = await _client.get(url(parent == null ? "tag" : "tag/${Uri.encodeComponent(parent)}/list"));
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
  final map = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  return Tag.fromJson(map);
}

Future<void> sendTagDeletion(Tag tag) async {
  await _client.delete(url("tag/${Uri.encodeComponent(tag.fullName())}"));
}

Future<void> sendTagRename(Tag tag, String newName) async {
  await _client.patch(
      url("tag/${Uri.encodeComponent(tag.fullName())}"),
      body: {"name": newName}
  );
}

Future<List<SavedFile>> getAllFiles({Order order = Order.dateModified, bool reversed = false}) async {
  final response = await _client.get(url("files/all"), headers: {"order": order.apiName, "reversed": reversed.toString()});
  final files = jsonDecode(utf8.decode(response.bodyBytes)) as List;
  return files.map((j) => SavedFile.fromJson(j)).toList();
}

Future<void> sendFileDeletion(SavedFile file) async {
  await _client.delete(url("file/${Uri.encodeComponent(file.name)}"));
}
