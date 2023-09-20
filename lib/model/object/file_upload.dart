import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:uuid/uuid.dart';

part 'file_upload.freezed.dart';

@freezed
class FileUpload with _$FileUpload {
  const factory FileUpload({
    required UuidValue uuid,
    required PlatformFile platformFile,
    required Stream<int>? stream,
    required CancelToken? cancelToken,
    required ResultFuture<SavedFileState>? savedFileFuture,
  }) = _FileUpload;
}
