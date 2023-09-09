import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/modules/browse/grid.dart';

import '../../management/tag/tag_view_model.dart';

class BrowseScreen extends ConsumerWidget {
  final String tagName;

  const BrowseScreen({required this.tagName, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayables = ref
        .watch(tagProvider(tagName))
        .whenData((tag) => [...tag.files, ...tag.children]);
    return DisplayableGrid(displayables: displayables);
  }
}
