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
    if (_first) {
      return const Center(child: Text("Choosing files..."));
    }
    final uploads = ref.watch(uploadsProvider);
    return Column(children: [
      Flexible(
          child: uploads.isEmpty
              ? const Center(child: Text("Nothing here."))
              : ListView.builder(
                  itemCount: uploads.length,
                  itemBuilder: (context, i) {
                    return UploadTile(uploads[i]);
                  })),
      Row(children: [
        Expanded(
            child: ListTile(
          title: const Center(child: Text("Upload More")),
          onTap: pickAndAdd,
        )),
        Expanded(
            child: ListTile(
          title: const Center(child: Text("Clear Uploads")),
          onTap: () => ref.read(uploadsProvider.notifier).clear(),
        ))
      ]),
    ]);
  }

  Future<void> pickAndAdd() async {
    final files = await pickFilesToUpload();
    ref.read(uploadsProvider.notifier).addAll(files);
  }

  void initialPick() async {
    if (_first) {
      await pickAndAdd();
      // note: we use _first to determine
      // when to display the list of uploads
      setState(() => _first = false);
    }
  }

  @override
  void initState() {
    super.initState();
    initialPick();
  }
}
