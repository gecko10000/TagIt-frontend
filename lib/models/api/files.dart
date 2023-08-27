import 'dart:convert';

import 'package:tagit_frontend/models/objects/saved_file.dart';

import 'base.dart';

class FileAPI {

  static Future<List<SavedFile>> getAllFiles({bool reversed = false}) async {
    final response = await client.get(url("files/all"),
        headers: {"order": "dateModified", "reversed": reversed.toString()});
    final files = jsonDecode(utf8.decode(response.bodyBytes)) as List;
    return files.map((j) => SavedFile.fromJson(j)).toList();
  }

  /*static StreamSubscription uploadFile(PlatformFile file,
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
  }*/

  static Future<void> rename(String currentName, String newName) async {
    await client.patch(url("file/${Uri.encodeComponent(currentName)}"),
        body: {"name": newName});
  }

  static Future<SavedFile?> getInfo(String name) async {
    try {
      final response =
      await client.get(url("file/${Uri.encodeComponent(name)}/info"));
      final map =
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return SavedFile.fromJson(map);
    } on RequestException catch (ex) {
      if (ex.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  static Future<void> _modifyTag(String file, String tag, bool add) async {
    await client.patch(
        url("file/${Uri.encodeComponent(file)}/${add ? "add" : "remove"}"),
        body: {
          "tags": jsonEncode([tag])
        });
  }

  static Future<void> addTag(String file, String tag) async {
    await _modifyTag(file, tag, true);
  }

  static Future<void> removeTag(String file, String tag) async {
    await _modifyTag(file, tag, false);
  }

  static Future<void> delete(String fileName) async {
    await client.delete(url("file/${Uri.encodeComponent(fileName)}"));
  }
}
