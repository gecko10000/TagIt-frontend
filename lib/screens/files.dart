import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tagit_frontend/objects/saved_file.dart';
import 'package:tagit_frontend/screens/common.dart';
import 'package:tagit_frontend/widgets/file_tile.dart';

import '../requests.dart';

class FileScreen extends StatelessWidget {
  const FileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleScaffold(
        title: "Files",
        body: ScrollableListView<SavedFile>((f) => FileTile(f), _loadFiles)
    );
  }

  Future<void> _loadFiles(int pageKey, PagingController<int, SavedFile> controller) async {
    try {
      final newItems = await retrieveFiles();
      final isLastPage = newItems.length < 20;
      if (isLastPage) {
        controller.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        controller.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      controller.error = error;
      print(error);
    }
  }

}
