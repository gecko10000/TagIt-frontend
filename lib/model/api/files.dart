import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:media_kit/media_kit.dart';
import 'package:tagit_frontend/model/enum/media_type.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:uuid/uuid.dart';

import 'base.dart';

class FileAPI {
  // no constructor
  FileAPI._();

  static Future<List<SavedFileState>> getAllFiles(
      {bool reversed = false}) async {
    final response = await client
        .get(url("files/all"), headers: {"reversed": reversed.toString()});
    final files = jsonDecode(utf8.decode(response.bodyBytes)) as List;
    return files.map((j) => SavedFileState.fromJson(j)).toList();
  }

  static (Stream<int>, Future<SavedFileState>) uploadFile(PlatformFile file) {
    final request =
        StreamedRequest("POST", url("file/${Uri.encodeComponent(file.name)}"));
    final stream = StreamController<int>();
    request.contentLength = file.size;
    int total = 0;
    file.readStream!.listen((chunk) {
      request.sink.add(chunk);
      total += chunk.length;
      stream.add(total);
    }, onError: (ex, st) {
      stream.addError(ex, st);
      request.sink.close();
      stream.close();
    }, onDone: () {
      request.sink.close();
      stream.close();
    });
    final future = client.send(request);
    final savedFileFuture = future.then((response) async {
      final responseString = await response.stream.bytesToString();
      final file = jsonDecode(responseString);
      return SavedFileState.fromJson(file);
    });
    return (stream.stream, savedFileFuture);
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

  static Future<void> rename(UuidValue fileId, String newName) async {
    await client.patch(url("file/${fileId.uuid}"), body: {"name": newName});
  }

  static Future<SavedFileState> getInfo(UuidValue fileId) async {
    final response = await client.get(url("file/${fileId.uuid}/info"));
    final map =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return SavedFileState.fromJson(map);
  }

  static Image getThumbnail(SavedFileState savedFile) {
    assert(savedFile.thumbnail);
    return Image.network(
      url("file/${savedFile.uuid}/thumb").toString(),
      headers: defaultHeaders(),
    );
  }

  static Image getImage(SavedFileState savedFile) {
    assert(savedFile.mediaType == MediaType.IMAGE);
    final dimensions = savedFile.dimensions;
    return Image.network(
      url("file/${savedFile.uuid}", queryParameters: fileGetParams())
          .toString(),
      width: dimensions?.width,
      height: dimensions?.height,
    );
  }

  static Media _getMedia(SavedFileState savedFile) {
    return Media(url("file/${savedFile.uuid}", queryParameters: fileGetParams())
        .toString());
  }

  static Media getVideo(SavedFileState savedFile) {
    assert(savedFile.mediaType == MediaType.VIDEO);
    return _getMedia(savedFile);
  }

  static Media getAudio(SavedFileState savedFile) {
    assert(savedFile.mediaType == MediaType.AUDIO);
    return _getMedia(savedFile);
  }

  static Future<void> _modifyTag(
      UuidValue fileId, UuidValue tagId, bool add) async {
    await client.patch(url("file/${fileId.uuid}/${add ? "add" : "remove"}"),
        body: {"tag": tagId.uuid});
  }

  static Future<void> addTag(UuidValue fileId, UuidValue tagId) async {
    await _modifyTag(fileId, tagId, true);
  }

  static Future<void> removeTag(UuidValue fileId, UuidValue tagId) async {
    await _modifyTag(fileId, tagId, false);
  }

  static Future<void> delete(UuidValue fileId) async {
    await client.delete(url("file/${fileId.uuid}"));
  }
}
