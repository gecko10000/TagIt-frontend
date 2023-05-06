import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/requests.dart';
import 'package:tagit_frontend/screens/common.dart';

part 'upload.g.dart';

@riverpod
class _FileUploads extends _$FileUploads {
  @override
  List<FileUpload> build() => [];

  void add(FileUpload upload) {
    state = [...state, upload];
  }

  void addAll(Iterable<FileUpload> uploads) {
    state = [...state, ...uploads];
  }

  void modify(int index, void Function(FileUpload) func) {
    func(state[index]);
    ref.notifyListeners();
  }
}

Future<List<PlatformFile>> _showUploadDialog(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    dialogTitle: "Choose Files to Upload",
    withReadStream: true,
  );
  return result?.files ?? [];
}

class FileUpload {
  final PlatformFile file;
  final StreamSubscription subscription;
  int progress = 0;
  String? error;
  bool completed = false;
  FileUpload({required this.file, required this.subscription});
}

// stateful because we use initState
// to open the file selector
class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    return BackScaffold(
      body: ListView.builder(
          itemCount: ref.watch(_fileUploadsProvider).length,
          itemBuilder: (context, i) {
            final upload = ref.watch(_fileUploadsProvider)[i];
            return ListTile(
              leading: Container(
                  color: Colors.yellow,
                  child: upload.error == null
                      ? upload.completed
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : CircularProgressIndicator(
                              value: upload.progress / upload.file.size,
                            )
                      : Tooltip(
                          message: upload.error,
                          child: const Icon(Icons.error, color: Colors.red))),
              title: Text(upload.file.name),
              // don't show cancellation button
              // if there's already an error
              trailing: upload.error != null || upload.completed
                  ? null
                  : IconButton(
                      onPressed: () {
                        // stop the subscription
                        ref.read(_fileUploadsProvider)[i].subscription.cancel();
                        // set the upload as cancelled
                        ref
                            .read(_fileUploadsProvider.notifier)
                            .modify(i, (u) => u.error = "Cancelled");
                      },
                      icon: const Icon(Icons.close)),
            );
          }),
      title: "Upload",
    );
  }

  void showInitialPrompt() async {
    final newFiles = await _showUploadDialog(context);
    final previousAmount = ref.read(_fileUploadsProvider).length;
    for (int i = 0; i < newFiles.length; i++) {
      final file = newFiles[i];
      // offset in the total list
      final uploadIndex = previousAmount + i;
      // declare as late so it can be used within the closures
      late StreamSubscription subscription;
      subscription = uploadFile(file, (progress) {
        if (!mounted) {
          subscription.cancel();
          return;
        }
        ref
            .read(_fileUploadsProvider.notifier)
            .modify(uploadIndex, (u) => u.progress = progress);
      }, (error) {
        if (!mounted) {
          subscription.cancel();
          return;
        }
        ref
            .read(_fileUploadsProvider.notifier)
            .modify(uploadIndex, (u) => u.error = error);
      }, () {
        ref
            .read(_fileUploadsProvider.notifier)
            .modify(uploadIndex, (u) => u.completed = true);
      });
      ref
          .read(_fileUploadsProvider.notifier)
          .add(FileUpload(file: file, subscription: subscription));
    }
  }

  @override
  void initState() {
    super.initState();
    showInitialPrompt();
  }
}
