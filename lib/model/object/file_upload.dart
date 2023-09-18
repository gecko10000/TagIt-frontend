import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';

part 'file_upload.freezed.dart';

@freezed
class FileUpload with _$FileUpload {
  const factory FileUpload({
    required PlatformFile platformFile,
    required Stream<int>? stream,
    required ResultFuture<SavedFileState>? savedFileFuture,
  }) = _FileUpload;
}
