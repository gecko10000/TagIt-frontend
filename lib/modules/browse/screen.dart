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
    final tagValue = ref.watch(tagProvider(tagId));
    return tagValue.when(
        data: (tag) {
          final body = TagBrowser(tag: tag, stackPush: stackPush);
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
          final titleString = tagName != null ? tagName! : "TagIt";
          final title = Tooltip(
              message: titleString,
              child: Text(
                titleString,
                overflow: TextOverflow.fade,
              ));
          final actions = [
            IconButton(
                onPressed: () => openCreateTagDialog(context, tag),
                icon: const Icon(Icons.add)),
            IconButton(
                onPressed: () => openSortingDialog(context),
                icon: const Icon(Icons.sort)),
            if (tagId != null)
              IconButton(
                  onPressed: () => openDeleteTagDialog(context, tag),
                  icon: const Icon(Icons.delete)),
            if (!stackPush)
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close))
          ];
          final appBar = AppBar(
            automaticallyImplyLeading: false,
            leading: leading,
            title: title,
            actions: actions,
          );
          return Scaffold(
            appBar: appBar,
            body: body,
          );
        },
        error: (ex, st) => Text("$ex\n$st"),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
