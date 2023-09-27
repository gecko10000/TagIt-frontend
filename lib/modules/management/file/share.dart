import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tagit_frontend/common/extension/build_context.dart';
import 'package:tagit_frontend/model/api/files.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';

void shareFile(BuildContext context, SavedFileState savedFile) async {
  // https://pub.dev/packages/share_plus#platform-support
  if (Platform.isWindows || Platform.isLinux) {
    context.showTextSnackBar("Sharing is not supported on this platform.");
  }
  final tempDir = await getTemporaryDirectory();
  final path = tempDir.uri.resolve(savedFile.name).path;
  await FileAPI.downloadFile(savedFile, path);
  Share.shareXFiles([XFile(path)]);
}
