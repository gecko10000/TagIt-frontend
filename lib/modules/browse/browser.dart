import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/object/tag.dart';

import 'grid.dart';

class TagBrowser extends ConsumerWidget {
  final TagState tag;
  final bool stackPush;

  const TagBrowser({required this.tag, this.stackPush = true, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayables = [...tag.children, ...tag.files];
    return DisplayableGrid(displayables: displayables, stackPush: stackPush);
  }
}
