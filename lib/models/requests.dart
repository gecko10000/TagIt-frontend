import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';

import 'objects/displayable.dart';
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

Box accountBox = Hive.box("account");

class APIClient extends BaseClient {
  final Client _client;

  APIClient(this._client);

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    request.headers.addAll(Requests.defaultHeaders());
    StreamedResponse response = await _client.send(request);
    // response code not 2XX
    if (response.statusCode != 422 && response.statusCode ~/ 100 != 2) {
      throw RequestException(
          response.statusCode, await response.stream.bytesToString());
    }
    return response;
  }
}

class Requests {
  static final Client _client = APIClient(Client());

  static Map<String, String> defaultHeaders() {
    final headers = <String, String>{};
    final token = accountBox.get("token");
    if (token != null) {
      headers["Authorization"] = "Bearer $token";
    }
    return headers;
  }

  static Uri url(String endpoint, {Map<String, dynamic>? queryParameters}) {
    return Uri.parse(accountBox.get("host"))
        .resolve(endpoint)
        .replace(queryParameters: queryParameters);
  }

  static Future<Tag> getTag(String name) async {
    final response = await _client.get(url("tag/${Uri.encodeComponent(name)}"));
    final map =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return Tag.fromJson(map);
  }

  static Future<List<Displayable>> retrieveChildren(String? parent) async {
    var response = await _client.get(url(
        parent == null ? "tag" : "tag/${Uri.encodeComponent(parent)}/list"));
    var map = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    List<Displayable> returned = [];
    returned.addAll(
        (map["children"] as List).map((e) => Displayable.tag(Tag.fromJson(e))));
    List? files = map["files"];
    if (files != null) {
      returned
          .addAll(files.map((e) => Displayable.file(SavedFile.fromJson(e))));
    }
    return returned;
  }

  static Future<void> sendTagDeletion(Tag tag) async {
    await _client.delete(url("tag/${Uri.encodeComponent(tag.fullName())}"));
  }

  static Future<void> sendTagRename(Tag tag, String newName) async {
    await _client.patch(url("tag/${Uri.encodeComponent(tag.fullName())}"),
        body: {"name": newName});
  }

  static Future<List<SavedFile>> getAllFiles({bool reversed = false}) async {
    final response = await _client.get(url("files/all"),
        headers: {"order": "dateModified", "reversed": reversed.toString()});
    final files = jsonDecode(utf8.decode(response.bodyBytes)) as List;
    return files.map((j) => SavedFile.fromJson(j)).toList();
  }

  static Future<void> sendFileDeletion(SavedFile file) async =>
      await sendFileDeletionByName(file.info.name);

  static Future<void> sendFileDeletionByName(String filename) async {
    await _client.delete(url("file/${Uri.encodeComponent(filename)}"));
  }

  static Future<void> sendFileRename(SavedFile file, String newName) async {
    await _client.patch(url("file/${Uri.encodeComponent(file.info.name)}"),
        body: {"name": newName});
  }

  static Future<void> sendPatchTag(String file, String tag, bool add) async {
    await _client.patch(
        url("file/${Uri.encodeComponent(file)}/${add ? "add" : "remove"}"),
        body: {
          "tags": jsonEncode([tag])
        });
  }

  static Future<void> sendTagCreation(String name) async {
    await _client.post(url("tag/${Uri.encodeComponent(name)}"));
  }

  static Future<bool> fileExists(String name) async {
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

  static StreamSubscription uploadFile(PlatformFile file,
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

  /*static Future<BackendInfo?> getBackendInfo({Uri? uri}) async {
    try {
      uri = (uri?.resolve ?? url)("tagit/version");
      final response = await _client.get(uri);
      if (response.statusCode != 200) return null;
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      return BackendInfo.fromJson(json);
    } catch (_) {
      return null;
    }
  }*/

  static Future<Response> _auth(
      String endpoint, String username, String password) async {
    final response = await _client.post(url("auth/$endpoint"),
        body: {"username": username, "password": password});
    return response;
  }

  static Future<String> login(String username, String password) async {
    final response = await _auth("login", username, password);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    return json["token"];
  }

  static Future<void> register(String username, String password) async =>
      await _auth("register", username, password);
}
