import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tagit_frontend/screens/common.dart';

import '../objects/tag.dart';
import '../objects/tileable.dart';
import '../requests.dart';

class BrowseScreen extends StatelessWidget {

  final Tag? parent;

  const BrowseScreen({super.key, this.parent});

  @override
  Widget build(BuildContext context) {
    return SimpleScaffold(
        title: parent?.fullName() ?? "Browse Tags",
        body: ScrollableListView<Tileable>((t) => t.createTile(context), _loadList),
        backButton: parent != null,
    );
  }

  Future<void> _loadList(int pageKey, PagingController<int, Tileable> controller) async {
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
