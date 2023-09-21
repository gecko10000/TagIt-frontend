import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:media_kit/media_kit.dart';
import 'package:tagit_frontend/model/enum/media_type.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:uuid/uuid.dart';

import '../object/file_upload.dart';
import 'base.dart';

class FileAPI {
  // no constructor
  FileAPI._();

  static Future<List<SavedFileState>> getAllFiles(
      {bool reversed = false}) async {
    final response = await client.get("/files/all",
        options: Options(headers: {"reversed": reversed.toString()}));
    final files = response.data as List;
    return files.map((j) => SavedFileState.fromJson(j)).toList();
  }

  static Future<SavedFileState> _internalUpload(PlatformFile file,
      StreamController<int> stream, CancelToken cancelToken) async {
    try {
      final upload = await client.post(
          "/file/${Uri.encodeComponent(file.name)}",
          data: file.readStream!,
          cancelToken: cancelToken,
          options: Options(
              headers: {Headers.contentLengthHeader: file.size},
              contentType: ContentType.binary.toString()),
          onSendProgress: (total, _) {
        stream.add(total);
      });
      return SavedFileState.fromJson(upload.data);
    } on DioException catch (ex, st) {
      stream.addError(ex, st);
      return Future.error(ex, st);
    }
  }

  static FileUpload uploadFile(UuidValue uuid, PlatformFile file) {
    final stream = StreamController<int>.broadcast();
    final cancelToken = CancelToken();
    final future = _internalUpload(file, stream, cancelToken);
    return FileUpload(
        uuid: uuid,
        platformFile: file,
        stream: stream.stream,
        savedFileFuture: ResultFuture(future),
        cancelToken: cancelToken);
  }

  // The first future is for choosing/getting the path.
  // The returned future is the download future.
  static Future<Future<void>?> downloadFile(
      SavedFileState savedFile, String path) async {
    final url = "/file/${savedFile.uuid.uuid}";
    final queryParams = fileGetParams();
    return client.download(url, path, queryParameters: queryParams);
  }

  static Future<void> rename(UuidValue fileId, String newName) async {
    await client.patch("/file/${fileId.uuid}",
        data: FormData.fromMap({"name": newName}));
  }

  static Future<SavedFileState> getInfo(UuidValue fileId) async {
    final response = await client.get("/file/${fileId.uuid}/info");
    return SavedFileState.fromJson(response.data);
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
    await client.patch("/file/${fileId.uuid}/${add ? "add" : "remove"}",
        data: FormData.fromMap({"tag": tagId.uuid}));
  }

  static Future<void> addTag(UuidValue fileId, UuidValue tagId) async {
    await _modifyTag(fileId, tagId, true);
  }

  static Future<void> removeTag(UuidValue fileId, UuidValue tagId) async {
    await _modifyTag(fileId, tagId, false);
  }

  static Future<void> delete(UuidValue fileId) async {
    await client.delete("/file/${fileId.uuid}");
  }

  static Future<bool> checkExists(String fileName) async {
    final response =
        await client.get("/file/exists/${Uri.encodeComponent(fileName)}");
    final exists = response.data["exists"];
    return exists;
  }
}
