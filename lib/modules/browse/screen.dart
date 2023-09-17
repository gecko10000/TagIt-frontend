import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/modules/browse/browser.dart';
import 'package:tagit_frontend/modules/browse/browser_model.dart';
import 'package:tagit_frontend/modules/management/tag/tag_view_model.dart';
import 'package:uuid/uuid.dart';

class BrowseScreen extends ConsumerWidget {
  final UuidValue? tagId;
  final String? tagName;

  // This variable defines whether or not navigating to a child
  // tag will push the new screen onto the navigation stack.
  // Used in the context of opening the browser from a tag.
  final bool stackPush;

  const BrowseScreen(
      {required this.tagId,
      required this.tagName,
      this.stackPush = true,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final body = TagBrowser(tagId: tagId, stackPush: stackPush);
    AppBar? appBar;
    if (tagId == null && stackPush) {
      appBar = null;
    } else {
      final leading = tagId == null
          ? null
          : IconButton(
              icon: const Icon(Icons.arrow_upward),
              onPressed: () async {
                if (stackPush) {
                  Navigator.pop(context);
                } else {
                  final tag = await ref.read(tagProvider(tagId).future);
                  if (context.mounted) {
                    popAndOpenTagBrowser(
                        context, tag.parentUUID, tag.parentName);
                  }
                }
              },
            );
      final title = tagName == null ? null : Text(tagName!);
      final actions = stackPush
          ? <Widget>[]
          : [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close))
            ];
      appBar = AppBar(
        automaticallyImplyLeading: false,
        leading: leading,
        title: title,
        actions: actions,
      );
    }
    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}
