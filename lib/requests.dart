import 'dart:convert';

import 'package:http/http.dart';

import 'objects/saved_file.dart';
import 'objects/tag.dart';
import 'objects/tileable.dart';

class APIClient extends BaseClient {

  final Client _client;

  APIClient(this._client);

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    return _client.send(request);
  }

}

APIClient _client = APIClient(Client());

Uri url(String endpoint) => Uri(scheme: 'http', host: "localhost", port: 10000, path: endpoint);

Future<List<Tileable>> retrieveChildren(String? parent) async {
  var response = await _client.get(url(parent == null ? "tag" : "tag/${Uri.encodeComponent(parent)}/list"));
  var map = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  List<Tileable> returned = [];
  returned.addAll((map["children"] as List).map((e) => Tag.fromJson(e)));
  List? files = map["files"];
  if (files != null) {
    returned.addAll(files!.map((e) => SavedFile.fromJson(e)));
  }
  return returned;
}
