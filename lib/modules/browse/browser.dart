import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../management/tag/tag_view_model.dart';
import 'grid.dart';

class TagBrowser extends ConsumerWidget {
  final UuidValue? tagId;
  final bool stackPush;

  const TagBrowser({required this.tagId, this.stackPush = true, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayables = ref
        .watch(tagProvider(tagId))
        .whenData((tag) => [...tag.files, ...tag.children]);
    return DisplayableGrid(displayables: displayables, stackPush: stackPush);
  }
}
