import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/modules/management/tag/saved_file_view_model.dart';

import '../management/tag/tag_view_model.dart';
import 'grid.dart';

class TagBrowser extends ConsumerWidget {
  final String tagName;

  const TagBrowser({required this.tagName, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayables = ref.watch(tagProvider(tagName)).whenData((tag) => [
          ...tag.files.map(
              (f) => ref.watch(savedFileProvider(f.name)).valueOrNull ?? f),
          ...tag.children
        ]);
    return DisplayableGrid(displayables: displayables);
  }
}
