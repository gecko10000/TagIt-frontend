import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../management/tag/tag_view_model.dart';
import 'grid.dart';

class TagBrowser extends ConsumerWidget {
  final String tagName;
  final bool stackPush;

  const TagBrowser({required this.tagName, this.stackPush = true, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayables = ref
        .watch(tagProvider(tagName))
        .whenData((tag) => [...tag.files, ...tag.children]);
    return DisplayableGrid(displayables: displayables, stackPush: stackPush);
  }
}
