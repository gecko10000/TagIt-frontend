import 'dart:convert';

import 'package:http/http.dart';

import 'objects/saved_file.dart';

class APIClient extends BaseClient {

  final Client _client;

  APIClient(this._client);

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    return _client.send(request);
  }
  
}

APIClient _client = APIClient(Client());

Uri url(String endpoint) => Uri.http("localhost:10000", endpoint);

Future<List<SavedFile>> retrieveFiles() async {
  var response = await _client.get(url("files/all"));
  var fileList = jsonDecode(utf8.decode(response.bodyBytes)) as List;

  return fileList.map((e) {
    return SavedFile.fromJson(e);
  }).toList();
}
