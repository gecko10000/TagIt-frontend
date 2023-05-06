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
  final int index;
  const _FileUploadTile(this.upload, {required this.index});

  Widget errorTile(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.error, color: Colors.red),
      isThreeLine: true,
      title: Text(upload.file.name),
      subtitle: Text(upload.error!),
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

  Widget inProgressTile(WidgetRef ref) {
    return ListTile(
      leading:
          CircularProgressIndicator(value: upload.progress / upload.file.size),
      isThreeLine: true,
      title: Text(upload.file.name),
      subtitle: Text(
          "${upload.progress.toByteUnits()}/${upload.file.size.toByteUnits()}"),
      trailing: IconButton(
        icon: const Icon(Icons.close),
        color: Colors.red,
        onPressed: () {
          FileUpload upload = ref.read(_fileUploadsProvider)[index];
          upload.error = "Cancelled";
          upload.subscription.cancel();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return upload.error != null
        ? errorTile(context, ref)
        : upload.completed
            ? completedTile()
            : inProgressTile(ref);
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
            return _FileUploadTile(upload, index: i);
          }),
      title: "Upload",
    );
  }

  void startUpload(
      BuildContext context, WidgetRef ref, PlatformFile file, int index) {
    // declare as late so it can be used within the closures
    late StreamSubscription subscription;
    subscription = uploadFile(file, onProgress: (progress) {
      if (!context.mounted) {
        subscription.cancel();
        return;
      }
      ref
          .read(_fileUploadsProvider.notifier)
          .modify(index, (u) => u.progress = progress);
    }, onError: (error) {
      if (!context.mounted) {
        subscription.cancel();
        return;
      }
      ref.read(_fileUploadsProvider.notifier).modify(index, (u) {
        u.completed = false;
        u.error = error;
      });
    }, onComplete: () {
      ref
          .read(_fileUploadsProvider.notifier)
          .modify(index, (u) => u.completed = true);
    });
    final uploadsNotifier = ref.read(_fileUploadsProvider.notifier);
    final newUpload = FileUpload(file: file, subscription: subscription);
    uploadsNotifier.add(newUpload);
  }

  void showInitialPrompt() async {
    final newFiles = await _showUploadDialog(context);
    final previousAmount = ref.read(_fileUploadsProvider).length;
    if (!context.mounted) return;
    for (int i = 0; i < newFiles.length; i++) {
      final file = newFiles[i];
      // offset in the total list
      final uploadIndex = previousAmount + i;
      startUpload(context, ref, file, uploadIndex);
    }
  }

  @override
  void initState() {
    super.initState();
    showInitialPrompt();
  }
}
