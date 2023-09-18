import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/modules/upload/upload_model.dart';
import 'package:tagit_frontend/modules/upload/upload_tile.dart';

bool _first = true;

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  @override
  Widget build(BuildContext context) {
    final uploads = ref.watch(uploadsProvider);
    return ListView.builder(
        itemCount: uploads.length + 1,
        itemBuilder: (context, i) {
          if (i == uploads.length) {
            return ListTile(
              title: const Text("Upload More"),
              onTap: pickAndAdd,
            );
          }
          return UploadTile(uploads[i]);
        });
  }

  void pickAndAdd() async {
    final files = await pickFilesToUpload();
    ref.read(uploadsProvider.notifier).addAll(files);
  }

  @override
  void initState() {
    super.initState();
    if (_first) {
      pickAndAdd();
      _first = false;
    }
  }
}
