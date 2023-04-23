import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/objects/saved_file.dart';
import 'package:tagit_frontend/requests.dart';

part 'file_browser.g.dart';

@riverpod
class FileBrowserList extends _$FileBrowserList {
  @override
  FutureOr<List<SavedFile>> build() => getAllFiles();

  void refresh() async => state = AsyncValue.data(await getAllFiles());

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
            itemBuilder: (context, i) => files[i].createTile(context: context, ref: ref, onTap: () {}),
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
