import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tagit_frontend/objects/saved_file.dart';
import 'package:tagit_frontend/widgets/file_widget.dart';

import '../objects/tag.dart';

class FileListView extends StatefulWidget {
  const FileListView({super.key});

  @override
  State createState() => _FileListViewState();

}

class _FileListViewState extends State<FileListView> {

  static const _pageSize = 20;

  final PagingController<int, SavedFile> _pagingController = PagingController(firstPageKey: 0);

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, SavedFile>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<SavedFile>(
        itemBuilder: (ctx, item, index) => FileTile(file: item)
      ),
    );
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _loadFiles(pageKey);
    });
    super.initState();
  }

  Future<void> _loadFiles(int pageKey) async {
    try {
      final newItems = [SavedFile("test"), SavedFile("test2", tags: [Tag("tag")])];
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

}
