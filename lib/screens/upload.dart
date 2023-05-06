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
  FileUpload({required this.file, required this.subscription});
}

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
                title: Row(children: [
                  Text(upload.file.name),
                  const SizedBox(width: 10),
                  upload.error == null
                      ? Expanded(
                          child: LinearProgressIndicator(
                          value: upload.progress / upload.file.size,
                        ))
                      : Tooltip(
                          message: upload.error,
                          child: const Icon(Icons.error, color: Colors.red)),
                ]),
                // don't show cancellation button
                // if there's already an error
                trailing: upload.error != null
                    ? null
                    : IconButton(
                        onPressed: () {
                          // stop the subscription
                          ref
                              .read(_fileUploadsProvider)[i]
                              .subscription
                              .cancel();
                          // set the upload as cancelled
                          ref
                              .read(_fileUploadsProvider.notifier)
                              .modify(i, (u) => u.error = "Cancelled");
                        },
                        icon: const Icon(Icons.close)),
              );
            }),
        title: "Upload",
        ref: ref);
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
