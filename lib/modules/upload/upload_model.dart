import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/model/api/files.dart';
import 'package:tagit_frontend/model/object/file_upload.dart';
import 'package:uuid/uuid.dart';

import '../../model/object/saved_file.dart';

part 'upload_model.g.dart';

final Map<UuidValue, FileUpload> uploads = {};

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
    state = [...state.where((upload) => upload.uuid != uuid)];
  }
}

@riverpod
class UploadedFile extends _$UploadedFile {
  @override
  Future<SavedFileState?> build(UuidValue uuid) async {
    final future = ref
        .watch(uploadsProvider)
        .singleWhere((f) => f.uuid == uuid)
        .savedFileFuture;
    return future;
  }
}

@riverpod
class Upload extends _$Upload {
  @override
  Future<FileUpload> build(PlatformFile file) => _uploadFile(file);
}

Future<FileUpload> _uploadFile(PlatformFile file) async {
  final exists = await FileAPI.checkExists(file.name);
  final uuid = UuidValue(const Uuid().v4());
  if (exists) {
    return FileUpload(
      uuid: uuid,
      platformFile: file,
      stream: null,
      cancelToken: null,
      savedFileFuture: null,
    );
  }
  return FileAPI.uploadFile(uuid, file);
}

Future<Iterable<FileUpload>> _uploadFiles(Iterable<PlatformFile> files) async {
  final uploads = await Future.wait(files.map((f) => _uploadFile(f)));
  return uploads;
}

Future<Iterable<FileUpload>> pickFilesToUpload() async {
  final result = await FilePicker.platform
      .pickFiles(allowMultiple: true, withReadStream: true);
  if (result == null) return [];
  return _uploadFiles(result.files);
}

void cancelAndClearUploads(WidgetRef ref) {
  for (final upload in ref.read(uploadsProvider)) {
    // TODO: cancel current uploads
  }
  ref.read(uploadsProvider.notifier).clear();
}
