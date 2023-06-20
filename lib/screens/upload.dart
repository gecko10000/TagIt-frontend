import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/misc/extensions.dart';
import 'package:tagit_frontend/requests.dart';
import 'package:tagit_frontend/screens/common.dart';

import '../widgets/browsers/file_browser.dart';

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
    lockParentWindow: true,
  );
  return result?.files ?? [];
}

class FileUpload {
  final PlatformFile file;
  final StreamSubscription? subscription;
  int progress = 0;
  String? error;
  bool completed = false;
  FileUpload({required this.file, this.subscription});
}

Widget _boxWidget(Widget child) {
  return SizedBox(width: 32, height: 32,
  child: child);
}

Widget _boxIcon(IconData data, {Color? color}) {
  return _boxWidget(Icon(data, color: color));
}

class _FileUploadTile extends ConsumerWidget {
  final FileUpload upload;
  final int index;
  const _FileUploadTile(this.upload, {required this.index});

  Widget errorTile(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: _boxIcon(Icons.error, color: Colors.red),
      isThreeLine: true,
      title: Text(upload.file.name),
      subtitle: Text(upload.error!),
    );
  }

  Widget completedTile() {
    return ListTile(
      leading: _boxIcon(Icons.check_circle, color: Colors.green),
      isThreeLine: true,
      title: Text(upload.file.name),
      subtitle: Text(upload.file.size.toByteUnits()),
    );
  }

  Widget inProgressTile(WidgetRef ref) {
    return ListTile(
      leading: _boxWidget(CircularProgressIndicator(
            value: upload.progress / upload.file.size),
      ),
      isThreeLine: true,
      title: Text(upload.file.name),
      subtitle: Text(
          "${upload.progress.toByteUnits()}/${upload.file.size.toByteUnits()}"),
      trailing: IconButton(
        icon: const Icon(Icons.close),
        color: Colors.red,
        onPressed: () {
          ref.read(_fileUploadsProvider.notifier).modify(index, (u) {
            u.error = "Cancelled";
            u.subscription?.cancel();
          });
          // TODO: consolidate the duplicates of this function
          // partial upload completed, we should delete any existing partial file
          sendFileDeletionByName(upload.file.name)
          // ignore any errors in case the file didn't actually upload at all
              .catchError((_){}, test: (ex) => ex is RequestException || ex is SocketException);
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

  bool shownInitial = false;

  @override
  Widget build(BuildContext context) {
    final uploads = ref.watch(_fileUploadsProvider);
    return BackScaffold(
      body: ListView.builder(
          itemCount: uploads.length + (shownInitial ? 1 : 0),
          itemBuilder: (context, i) {
            if (i == uploads.length) {
              return ListTile(
                leading: _boxIcon(Icons.add),
                onTap: showPrompt,
                title: const Text("Upload More")
              );
            }
            final upload = uploads[i];
            return _FileUploadTile(upload, index: i);
          }),
      title: "Upload",
    );
  }

  void startUpload(
      BuildContext context, WidgetRef ref, PlatformFile file, int index) async {
    // we have to create the subscription
    String? preError;
    try {
      if (await fileExists(file.name)) {
        preError = "File already exists.";
        //uploadsNotifier.modify(index, (u) => u.error = "File already exists.");
      }
    } on Exception catch (ex) {
      preError = ex.toString();
      //uploadsNotifier.modify(index, (u) => u.error = ex.toString());
    }

    final uploadsNotifier = ref.read(_fileUploadsProvider.notifier);
    if (preError != null) {
      final newUpload = FileUpload(file: file);
      newUpload.error = preError;
      uploadsNotifier.add(newUpload);
      return;
    }

    // declare as late so it can be used within the closures
    late StreamSubscription subscription;
    subscription = uploadFile(file, onProgress: (progress) {
      if (!context.mounted) {
        subscription.cancel();
        return;
      }
      // update progress
      ref
          .read(_fileUploadsProvider.notifier)
          .modify(index, (u) => u.progress = progress);
    }, onError: (error) {
      subscription.cancel();
      if (context.mounted) {
        // update error
        ref.read(_fileUploadsProvider.notifier).modify(index, (u) {
          u.completed = false;
          u.error = error;
        });
      }
      // partial upload completed, we should delete any existing partial file
      sendFileDeletionByName(file.name)
      // ignore any errors in case the file didn't actually upload at all
      .catchError((_){}, test: (ex) => ex is RequestException || ex is SocketException);
    }, onComplete: () {
      // update completion status
      ref
          .read(_fileUploadsProvider.notifier)
          .modify(index, (u) => u.completed = true);
      // refresh files and tags
      ref.invalidate(fileBrowserListProvider);
    });
    final newUpload = FileUpload(file: file, subscription: subscription);
    uploadsNotifier.add(newUpload);
  }

  Future<void> showPrompt() async {
    final newFiles = await _showUploadDialog(context);
    if (!mounted) return;
    final previousAmount = ref.read(_fileUploadsProvider).length;
    for (int i = 0; i < newFiles.length; i++) {
      final file = newFiles[i];
      // offset in the total list
      final uploadIndex = previousAmount + i;
      startUpload(context, ref, file, uploadIndex);
    }
  }

  void _showInitialPrompt() async {
    await showPrompt();
    if (!mounted) return;
    setState(() => shownInitial = true);
  }

  @override
  void initState() {
    super.initState();
    _showInitialPrompt();
  }
}
