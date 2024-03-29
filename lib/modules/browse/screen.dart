import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/api/files.dart';
import 'package:tagit_frontend/modules/browse/browser.dart';
import 'package:tagit_frontend/modules/browse/browser_model.dart';
import 'package:tagit_frontend/modules/home/home_model.dart';
import 'package:tagit_frontend/modules/management/tag/tag_view_model.dart';
import 'package:tagit_frontend/modules/upload/upload_model.dart';
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
          final titleString = tagName ?? "TagIt";
          final controller = ScrollController(
              onAttach: (p) => Future(() => p.animateTo(p.maxScrollExtent,
                  duration: const Duration(seconds: 1),
                  curve: Curves.decelerate)));
          final title = Scrollbar(
              // only interactive on desktop platforms
              interactive: !(Platform.isIOS || Platform.isAndroid),
              scrollbarOrientation: ScrollbarOrientation.bottom,
              controller: controller,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: controller,
                  child:
                      Text(titleString, style: const TextStyle(fontSize: 20))));
          /*final title = Text(
            titleString,
            maxLines: 1,
            softWrap: false,
            style: const TextStyle(fontSize: 20, overflow: TextOverflow.fade),
          );*/
          final titleButton = tagName == null
              ? title
              : TextButton(
                  onPressed: () =>
                      openRenameTagDialog(context, tag, stackPush: stackPush),
                  style: ButtonStyle(foregroundColor:
                      MaterialStateProperty.resolveWith((states) {
                    return states.contains(MaterialState.hovered)
                        ? Colors.blue
                        : Colors.white;
                  })),
                  child: title);
          final titleTooltip =
              Tooltip(message: titleString, child: titleButton);
          final actions = [
            PopupMenuButton<String>(
                icon: const Icon(Icons.add),
                onSelected: (choice) async {
                  if (choice == "tag") {
                    openCreateTagDialog(context, tag);
                  } else if (choice == "file") {
                    final files = await pickFilesToUpload();
                    final uploads = await uploadFiles(files);
                    ref.read(uploadsProvider.notifier).addAll(uploads);
                    ref.read(homeIndexProvider.notifier).state =
                        uploadPageIndex;
                    for (final upload in uploads) {
                      final future = upload.savedFileFuture;
                      if (future == null) continue;
                      future.then((file) async {
                        await FileAPI.addTag(file.uuid, tag.uuid);
                        ref.invalidate(tagProvider(tag.uuid));
                      });
                    }
                  }
                },
                itemBuilder: (c) => [
                      const PopupMenuItem(value: "tag", child: Text("Tag")),
                      const PopupMenuItem(value: "file", child: Text("File")),
                    ]),
            if (tagId != null)
              IconButton(
                  onPressed: () => openDeleteTagDialog(context, tag),
                  icon: const Icon(Icons.delete)),
            IconButton(
                onPressed: () => openSortingDialog(context),
                icon: const Icon(Icons.sort)),
            if (stackPush && tagId == null)
              IconButton(
                  onPressed: () => openAllFiles(context),
                  icon: const Icon(Icons.file_copy_sharp)),
            if (!stackPush)
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close)),
          ];
          final appBar = AppBar(
            automaticallyImplyLeading: false,
            leading: leading,
            title: titleTooltip,
            actions: actions,
          );
          return Scaffold(
            appBar: appBar,
            body: body,
          );
        },
        error: (ex, st) => Scaffold(appBar: AppBar(), body: Text("$ex\n$st")),
        loading: () => Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator())));
  }
}
