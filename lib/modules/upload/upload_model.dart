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
    for (final upload in state) {
      upload.cancelToken?.cancel();
    }
    state = [];
  }

  void removeByUuid(UuidValue uuid) {
    state = [
      ...state.where((upload) {
        if (upload.uuid == uuid) {
          upload.cancelToken?.cancel();
        }
        return upload.uuid != uuid;
      })
    ];
  }

  // Note: the upload is complete at this
  // point so there's no need to cancel it
  void removeBySavedFileUuid(UuidValue uuid) {
    state = [
      ...state.where((upload) {
        final savedFileFuture = upload.savedFileFuture;
        if (savedFileFuture == null) return true;
        final savedFile = savedFileFuture.result?.asValue?.value;
        if (savedFile == null) return true;
        return savedFile.uuid != uuid;
      })
    ];
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

Future<Iterable<FileUpload>> uploadFiles(Iterable<PlatformFile> files) async {
  final uploads = await Future.wait(files.map((f) => _uploadFile(f)));
  return uploads;
}

Future<Iterable<PlatformFile>> pickFilesToUpload() async {
  final result = await FilePicker.platform
      .pickFiles(allowMultiple: true, withReadStream: true);
  if (result == null) return [];
  return result.files;
}

void cancelAndClearUploads(WidgetRef ref) {
  for (final upload in ref.read(uploadsProvider)) {
    // TODO: cancel current uploads
  }
  ref.read(uploadsProvider.notifier).clear();
}
