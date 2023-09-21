import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tagit_frontend/model/api/files.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/modules/management/file/download_web.dart';

import '../../../common/extension/build_context.dart';

void downloadFile(BuildContext context, SavedFileState savedFile) async {
  if (kIsWeb) {
    downloadWeb(savedFile);
  }
  final path = await getPlatformPath(savedFile);
  if (path == null) return;
  final future = FileAPI.downloadFile(savedFile, path);

  showStaticSnackBar(const Text("Saving..."));
  await future;
  showStaticSnackBar(const Text("Download complete."));
}

Future<bool> _iosPermissions() async {
  final storageAccess = await Permission.storage.request();
  if (storageAccess.isPermanentlyDenied) {
    await openAppSettings();
  }
  return storageAccess.isGranted;
}

// TODO: make these work with Android 30+
// https://stackoverflow.com/a/66366102
Future<bool> _androidPermissions() async {
  final storageAccess = await Permission.storage.request();
  if (storageAccess.isPermanentlyDenied) {
    await openAppSettings();
  }
  return storageAccess.isGranted;
}

const androidDownloadPath = "/storage/emulated/0/Download/tagit";

// platform-dependent downloading and paths
// wtf is fuschia? I assume it's supported like Linux.
Future<String?> getPlatformPath(SavedFileState savedFile) async {
  if (kIsWeb) return null;
  if (Platform.isLinux ||
      Platform.isMacOS ||
      Platform.isWindows ||
      Platform.isFuchsia) {
// TODO: save previously used directory as initial directory
    return await FilePicker.platform.saveFile(fileName: savedFile.name);
  }
  if (Platform.isAndroid) {
    _androidPermissions();
    return "$androidDownloadPath/${savedFile.name}";
  }
// iOS
  _iosPermissions();
  final downloadsDir = await getDownloadsDirectory();
  if (downloadsDir == null) return null;
  if (!downloadsDir.existsSync()) downloadsDir.createSync();
  return downloadsDir.uri.resolve(savedFile.name).path;
}
