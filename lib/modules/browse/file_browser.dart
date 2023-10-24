import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/modules/browse/browser_model.dart';
import 'package:tagit_frontend/modules/browse/grid.dart';
import 'package:tagit_frontend/modules/management/file/saved_file_view_model.dart';

class FileBrowser extends ConsumerWidget {
  const FileBrowser({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () => print("Upload file"),
            icon: const Icon(Icons.file_upload)),
        IconButton(
            onPressed: () => openSortingDialog(context),
            icon: const Icon(Icons.sort))
      ]),
      body: ref.watch(allFilesProvider).when(
          data: (files) => DisplayableGrid(displayables: files),
          error: (ex, st) => Text("$ex\n$st"),
          loading: () => const CircularProgressIndicator()),
    );
  }
}
