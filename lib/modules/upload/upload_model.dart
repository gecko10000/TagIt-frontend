import 'package:file_picker/file_picker.dart';
import 'package:tagit_frontend/model/api/files.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';

void pickFilesToUpload() async {
  final result = await FilePicker.platform
      .pickFiles(allowMultiple: true, withReadStream: true);
  if (result == null) return;
  final futures = <Future<SavedFileState>>[];
  for (final file in result.files) {
    final (upload, savedFileFuture) = FileAPI.uploadFile(file);
    futures.add(savedFileFuture);
  }
  for (final future in futures) {
    final savedFile = await future;
    print(savedFile);
  }
}
