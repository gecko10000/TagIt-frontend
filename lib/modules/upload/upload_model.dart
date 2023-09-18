import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/model/api/files.dart';
import 'package:tagit_frontend/model/object/file_upload.dart';
import 'package:uuid/uuid.dart';

part 'upload_model.g.dart';

@Riverpod(keepAlive: true)
class Uploads extends _$Uploads {
  @override
  List<FileUpload> build() => [];

  void addAll(Iterable<FileUpload> uploads) {
    state = [...state, ...uploads];
  }

  void clear() {
    state = [];
  }

  Future<void> removeByUuid(UuidValue uuid) async {
    state = [
      ...state.where((upload) {
        final complete = upload.savedFileFuture?.isComplete ?? false;
        if (!complete) {
          return true;
        }
        final result = upload.savedFileFuture!.result!;
        if (result.isError) {
          return true;
        }
        return result.asValue!.value.uuid != uuid;
      })
    ];
  }
}

Future<FileUpload> _uploadFile(PlatformFile file) async {
  final exists = await FileAPI.checkExists(file.name);
  if (exists) {
    return FileUpload(
      platformFile: file,
      stream: null,
      savedFileFuture: null,
    );
  }
  final (stream, savedFileFuture) = FileAPI.uploadFile(file);
  return FileUpload(
    platformFile: file,
    stream: stream,
    savedFileFuture: ResultFuture(savedFileFuture),
  );
}

Future<Iterable<FileUpload>> _uploadFiles(Iterable<PlatformFile> files) async {
  final futures = <Future<FileUpload>>[];
  for (final file in files) {
    futures.add(_uploadFile(file));
  }
  final uploads = <FileUpload>[];
  for (final future in futures) {
    uploads.add(await future);
  }
  return uploads;
}

Future<Iterable<FileUpload>> pickFilesToUpload() async {
  final result = await FilePicker.platform
      .pickFiles(allowMultiple: true, withReadStream: true);
  if (result == null) return [];
  return _uploadFiles(result.files);
}
