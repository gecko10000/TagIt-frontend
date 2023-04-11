import 'dart:convert';

import 'package:http/http.dart';

import 'objects/tag.dart';

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

Future<List<Tag>> retrieveTagChildren(String? parent) async {
  var response = await _client.get(url(parent == null ? "tag" : "tag/${Uri.encodeComponent(parent)}/children"));
  var fileList = jsonDecode(utf8.decode(response.bodyBytes)) as List;

  return fileList.map((e) => Tag.fromJson(e)).toList();
}
