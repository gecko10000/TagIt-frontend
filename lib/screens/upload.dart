import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/misc/extensions.dart';
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

class _FileUploadTile extends ConsumerWidget {
  final FileUpload upload;
  const _FileUploadTile(this.upload);

  Widget errorTile() {
    return ListTile(
      leading: const Icon(Icons.error, color: Colors.red),
      isThreeLine: true,
      title: Text(upload.file.name),
      subtitle: Text("Failed: ${upload.error!}"),
    );
  }

  Widget completedTile() {
    return ListTile(
      leading: const Icon(Icons.check_circle, color: Colors.green),
      isThreeLine: true,
      title: Text(upload.file.name),
      subtitle: Text(upload.file.size.toByteUnits()),
    );
  }

  Widget inProgressTile() {
    return ListTile(
      leading: CircularProgressIndicator(value: upload.progress / upload.file.size),
      isThreeLine: true,
      title: Text(upload.file.name),
      subtitle: Text("${upload.progress.toByteUnits()}/${upload.file.size.toByteUnits()}"),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return upload.error != null
        ? errorTile()
        : upload.completed
            ? completedTile()
            : inProgressTile();
  }
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
            return _FileUploadTile(upload);
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
      subscription = uploadFile(file, onProgress: (progress) {
        if (!mounted) {
          subscription.cancel();
          return;
        }
        ref
            .read(_fileUploadsProvider.notifier)
            .modify(uploadIndex, (u) => u.progress = progress);
      }, onError: (error) {
        if (!mounted) {
          subscription.cancel();
          return;
        }
        ref.read(_fileUploadsProvider.notifier).modify(uploadIndex, (u) {
          u.completed = false;
          u.error = error;
        });
      }, onComplete: () {
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
