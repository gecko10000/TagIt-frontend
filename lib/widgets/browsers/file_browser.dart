import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/objects/saved_file.dart';
import 'package:tagit_frontend/requests.dart';
import 'package:tagit_frontend/widgets/content_viewer.dart';
import 'package:tagit_frontend/widgets/error_display.dart';

part 'file_browser.g.dart';

@riverpod
class FileBrowserList extends _$FileBrowserList {
  @override
  FutureOr<List<SavedFile>> build() => getAllFiles();
}

class FileBrowser extends ConsumerStatefulWidget {
  const FileBrowser({super.key});

  @override
  ConsumerState createState() => _FileBrowserState();
}

class _FileBrowserState extends ConsumerState<FileBrowser>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final fileFuture = ref.watch(fileBrowserListProvider);
    return Center(
        child: fileFuture.when(
      data: (files) {
        if (files.isEmpty) {
          return const Align(
            alignment: Alignment.center,
            child: Text(
              "Nothing here.",
              style: TextStyle(fontSize: 32),
            ),
          );
        }
        return ListView.builder(
          itemCount: files.length,
          itemBuilder: (context, i) => files[i].createTile(
              context: context,
              ref: ref,
              onTap: () => openContentView(context, files[i])),
        );
      },
      error: (err, st) => ErrorDisplay(text: err.toString()),
      loading: () => const CircularProgressIndicator(),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
