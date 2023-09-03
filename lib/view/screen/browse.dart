import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/view/widget/displayable_grid.dart';
import 'package:tagit_frontend/view_model/browse.dart';

class BrowseScreen extends ConsumerWidget {
  final String tagName;

  const BrowseScreen({required this.tagName, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
        alignment: Alignment.topCenter,
        child: ref.watch(browseListProvider(tagName)).when(
            data: (tag) => DisplayableGrid(
                parentTag: tag, displayables: [...tag.files, ...tag.children]),
            error: (ex, st) => Text("Error: $ex"),
            loading: () => const CircularProgressIndicator()));
  }
}
