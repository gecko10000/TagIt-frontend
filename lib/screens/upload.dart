import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/misc/extensions.dart';
import 'package:tagit_frontend/screens/common.dart';

import '../requests.dart';

Future<void> _uploadFiles(BuildContext context, {String? initialTag}) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    allowCompression: false,
    dialogTitle: "Choose Files to Upload",
    withReadStream: true,
  );
  if (result == null) return;
  List<Future> uploads = [];
  int failed = 0;
  Set<String> errors = {};
  for (final PlatformFile file in result.files) {
    Future<void> upload = uploadFile(file.name, file.size, file.readStream!)
        .catchError((ex, st) async {
      failed++;
      errors.add(ex.message);
    });
    uploads.add(upload);
  }
  await Future.wait(uploads);
  if (!context.mounted) return;
  int files = uploads.length;
  if (failed == 0) {
    context.showSnackBar("Uploaded $files file${files.smartS()}");
  } else {
    context.showSnackBar("$failed/$files upload${files.smartS()} failed due to: ${errors.join(", ")}");
  }
}

class UploadScreen extends ConsumerWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BackScaffold(body: TextButton(child: const Text("Upload"), onPressed: () => _uploadFiles(context),), title: "Upload", ref: ref);
  }

}
