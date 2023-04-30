import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/objects/saved_file.dart';
import 'package:tagit_frontend/requests.dart';
import 'package:tagit_frontend/widgets/content_viewer.dart';

part 'file_browser.g.dart';

@riverpod
class FileBrowserList extends _$FileBrowserList {
  @override
  FutureOr<List<SavedFile>> build() => getAllFiles();

  void refresh() async {
    try {
      state = AsyncValue.data(
          await getAllFiles());
    } on SocketException catch (ex, st) {
      state = AsyncValue.error(ex, st);
    }
  }

}

class FileBrowser extends ConsumerStatefulWidget {
  const FileBrowser({super.key});

  @override
  ConsumerState createState() => _FileBrowserState();

}

class _FileBrowserState extends ConsumerState<FileBrowser> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final fileFuture = ref.watch(fileBrowserListProvider);
    return fileFuture.when(
        data: (files) {
          if (files.isEmpty) {
            return const Align(
              alignment: Alignment.center,
              child: Text("Nothing here.",
                style: TextStyle(fontSize: 32),
              ),
            );
          }
          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, i) => files[i].createTile(context: context, ref: ref, onTap: () => openContentView(context, files[i])),
          );
        },
        error: (err, st) => Align(
          alignment: Alignment.center,
          child: Text("Error: $err"),
        ),
        loading: () => const Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        )
    );
  }

  @override
  bool get wantKeepAlive => true;

}
