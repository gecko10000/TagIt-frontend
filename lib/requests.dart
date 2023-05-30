import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:tagit_frontend/screens/search.dart';

import 'misc/order.dart';
import 'objects/common.dart';
import 'objects/saved_file.dart';
import 'objects/tag.dart';

class RequestException implements Exception {
  final int statusCode;
  final String message;
  const RequestException(this.statusCode, this.message);
  @override
  String toString() {
    final start = "Error: $statusCode";
    return message.isEmpty ? start : "$start - $message";
  }
}

Map<String, String> defaultHeaders() {
  final headers = <String, String>{};
  final token = box.get("token");
  if (token != null) {
    headers["Authorization"] = "Bearer ${box.get("token")}";
  }
  return headers;
}

class APIClient extends BaseClient {
  final Client _client;
  APIClient(this._client);

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    request.headers.addAll(defaultHeaders());
    StreamedResponse response = await _client.send(request);
    if (response.statusCode == 401) {
      await box.put("error", "Not Authenticated");
      await box.delete("token");
      return response;
    }
    // response code not 2XX
    if (response.statusCode != 422 && response.statusCode ~/ 100 != 2) {
      throw RequestException(
          response.statusCode, await response.stream.bytesToString());
    }
    return response;
  }
}

Client _client = APIClient(Client());

Box box = Hive.box("account");

Uri url(String endpoint, {Map<String, dynamic>? queryParameters}) {
  return Uri.parse(box.get("host"))
      .resolve(endpoint)
      .replace(queryParameters: queryParameters);
}

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

Future<void> sendFileDeletion(SavedFile file) async =>
    await sendFileDeletionByName(file.name);

Future<void> sendFileDeletionByName(String filename) async {
  await _client.delete(url("file/${Uri.encodeComponent(filename)}"));
}

Future<void> sendFileRename(SavedFile file, String newName) async {
  await _client.patch(url("file/${Uri.encodeComponent(file.name)}"),
      body: {"name": newName});
}

Future<List<SavedFile>> sendFileSearch(String query) async {
  Response response =
      await _client.get(url("search/files", queryParameters: {"q": query}));
  final json = jsonDecode(utf8.decode(response.bodyBytes));
  if (response.statusCode == 422) {
    // TODO: find a better way to bubble the index up
    // `json` is an int here
    throw SearchFormatException(json);
  }
  return (json as List).map((j) => SavedFile.fromJson(j)).toList();
}

Future<void> sendPatchTag(String file, String tag, bool add) async {
  await _client.patch(
      url("file/${Uri.encodeComponent(file)}/${add ? "add" : "remove"}"),
      body: {
        "tags": jsonEncode([tag])
      });
}

Future<List<Tag>> sendTagSearch(String substring) async {
  Response response =
      await _client.get(url("search/tags", queryParameters: {"q": substring}));
  final json = jsonDecode(utf8.decode(response.bodyBytes));
  return (json as List).map((j) => Tag.fromJson(j)).toList();
}

Future<void> sendTagCreation(String name) async {
  await _client.post(url("tag/${Uri.encodeComponent(name)}"));
}

Future<bool> fileExists(String name) async {
  try {
    await _client.get(url("file/${Uri.encodeComponent(name)}/tags"));
    return true;
    // no file = 404
  } on RequestException catch (ex) {
    if (ex.statusCode == 404) {
      return false;
    }
    rethrow;
  }
}

StreamSubscription uploadFile(PlatformFile file,
    {required void Function(int) onProgress,
    required void Function(String) onError,
    required void Function() onComplete}) {
  final request =
      StreamedRequest("POST", url("file/${Uri.encodeComponent(file.name)}"));
  request.contentLength = file.size;
  int progress = 0;
  final subscription = file.readStream!.listen((chunk) {
    request.sink.add(chunk);
    progress += chunk.length;
    onProgress(progress);
  },
      // don't call onComplete here
      // we do this when we can confirm that
      // the request went through properly
      onDone: () {
    request.sink.close();
  }, onError: (e) {
    request.sink.addError(e);
    request.sink.close();
    onError(e.toString());
  });
  // use .then to ignore the StreamedResponse
  // this makes it so onError does not expect
  // a StreamedResponse as a return value
  _client.send(request).then((_) => onComplete()).onError((error, _) {
    onError(error is RequestException ? error.message : error.toString());
    subscription.cancel();
  });
  return subscription;
}

Future<String?> getVersion({Uri? uri}) async {
  try {
    uri = (uri?.resolve ?? url)("tagit/version");
    final response = await _client.get(uri);
    if (response.statusCode != 200) return null;
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    return json["version"];
  } catch (_) {
    return null;
  }
}

Future<Response> _auth(String endpoint, String username, String password) async {
  final response = await _client.post(url("auth/$endpoint"),
      body: {"username": username, "password": password});
  return response;
}

Future<String> login(String username, String password) async {
  final response = await _auth("login", username, password);
  final json = jsonDecode(utf8.decode(response.bodyBytes));
  return json["token"];
}

Future<ByteStream> getFileStream(SavedFile file) async {
  final request = Request("GET", url("file/${Uri.encodeComponent(file.name)}"));
  final response = await _client.send(request);
  // convert chunks of ints (List<int>) to one big int stream
  return response.stream;
}

Future<void> register(String username, String password) async => await _auth("register", username, password);
