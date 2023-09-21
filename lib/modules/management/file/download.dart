import 'package:tagit_frontend/model/api/files.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';

void downloadFile(SavedFileState savedFile) {
  FileAPI.downloadFile(savedFile);
}
