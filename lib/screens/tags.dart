import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tagit_frontend/screens/common.dart';
import 'package:tagit_frontend/widgets/tag_tile.dart';

import '../objects/tag.dart';
import '../requests.dart';

class TagScreen extends StatelessWidget {
  const TagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleScaffold(ScrollableListView<Tag>((t) => TagTile(t), _loadTags));
  }

  Future<void> _loadTags(int pageKey, PagingController<int, Tag> controller) async {
    try {
      final newItems = await retrieveTags();
      final isLastPage = newItems.length < 20;
      if (isLastPage) {
        controller.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        controller.appendPage(newItems, nextPageKey);
      }
    } catch (error, t) {
      controller.error = error;
      print("ERROR: $error");
      print(t);
    }
  }

}
