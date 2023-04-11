import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tagit_frontend/screens/common.dart';
import 'package:tagit_frontend/widgets/tag_tile.dart';

import '../objects/tag.dart';
import '../requests.dart';

class TagScreen extends StatelessWidget {

  final Tag? parent;

  const TagScreen({super.key, this.parent});

  @override
  Widget build(BuildContext context) {
    return SimpleScaffold(
        title: parent == null ? "Tags" : "Tag: ${parent?.fullName()}",
        body: ScrollableListView<Tag>((t) => TagTile(t), _loadTags)
    );
  }

  Future<void> _loadTags(int pageKey, PagingController<int, Tag> controller) async {
    try {
      final newItems = await retrieveChildren(parent?.fullName());
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
