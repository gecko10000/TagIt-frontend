import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/view/widget/displayable_grid.dart';
import 'package:tagit_frontend/view_model/browse.dart';

class BrowseScreen extends ConsumerWidget {
  final String tagName;

  const BrowseScreen({required this.tagName, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayables = ref
        .watch(browseListProvider(tagName))
        .whenData((tag) => [...tag.files, ...tag.children]);
    return DisplayableGrid(displayables: displayables);
  }
}
