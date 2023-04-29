import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/misc/extensions.dart';
import 'package:tagit_frontend/objects/common.dart';
import 'package:tagit_frontend/objects/tag.dart';
import 'package:tagit_frontend/screens/common.dart';
import 'package:tagit_frontend/widgets/browsers/tag_browser.dart';

import '../requests.dart';
import '../widgets/browsers/file_browser.dart';

class SavedFile implements Tileable {
  final String name;
  final Set<String> tags = {};

  factory SavedFile.fromJson(Map<String, dynamic> json) {
    return SavedFile(json["name"],
        tags: (json["tags"] as List?)?.map((e) => e as String).toList() ?? []);
  }

  SavedFile(this.name, {List<String> tags = const []}) {
    this.tags.addAll(tags);
  }

  void renameFile(BuildContext context, WidgetRef ref) {
    TextEditingController controller = TextEditingController(text: name);
    // put cursor at the end of the filename but before the last period
    var startIndex = name.lastIndexOf(RegExp(r'\.'));
    startIndex = startIndex == -1 ? name.length : startIndex;
    controller.selection =
        TextSelection(baseOffset: startIndex, extentOffset: startIndex);

    Future<void> renameCallback(String newName, WidgetRef ref) async {
      try {
        await sendFileRename(this, newName);
      } on RequestException catch (ex, _) {
        context.showSnackBar(ex.message);
      }
      ref.read(fileBrowserListProvider.notifier).refresh();
    }

    renameObject(context, "file", name, renameCallback, controller, ref);
  }

  void deleteFile(BuildContext context, WidgetRef ref) {
    Future<void> deleteCallback(WidgetRef ref) async {
      try {
        await sendFileDeletion(this);
      } on RequestException catch (ex, _) {
        context.showSnackBar(ex.message);
      }
      ref.read(fileBrowserListProvider.notifier).refresh();
    }

    deleteObject(context, "file", name, deleteCallback, ref);
  }

  Future<void> _patchTag(BuildContext context, String tag, bool add) async {
    try {
      await sendPatchTag(name, tag, add);
    } on RequestException catch (ex, st) {
      context.showSnackBar(ex.message);
    }
  }

  void _addTag(BuildContext context, WidgetRef ref) {
    TextEditingController controller = TextEditingController();
    Future<String?> dialogReturn = showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Adding Tag to \"$name\""),
              content: Stack(
                children: [
                  TextField(
                    onSubmitted: ((name) => Navigator.pop(context, name)),
                    controller: controller,
                    autofocus: true,
                    autocorrect: false,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pop(context, controller.value.text),
                  child: const Text("Add"),
                ),
              ],
            ));
    dialogReturn.then((value) async {
      if (value == null) return;
      await _patchTag(context, value, true);
      ref.read(fileBrowserListProvider.notifier).refresh();

    });
  }

  void _removeTag(BuildContext context, String tagName, WidgetRef ref) {
    Future<bool?> dialogReturn = showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Remove tag $tagName from \"$name\"?"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel")),
                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Remove")),
              ],
            ));
    dialogReturn.then((value) async {
      if (value ?? false) {
        await _patchTag(context, tagName, false);
        ref.read(fileBrowserListProvider.notifier).refresh();
      }
    });
  }

  void _showTagMenu(BuildContext context, String tagName, Offset offset, WidgetRef ref) {
    showMenu<String>(
        context: context,
        position:
            RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx, offset.dy),
        items: const [
          PopupMenuItem(value: "view", child: Text("View Tag")),
          PopupMenuItem(
            value: "remove",
            child: Text("Remove", style: TextStyle(color: Colors.red)),
          )
        ]).then((value) async {
      if (value == "view") {
        Tag tag = await getTag(tagName);
        if (!context.mounted) return;
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          builder: (context) => BackScaffold(
            body: TagBrowserNavigator(
              scaffoldNameNotifier: backScaffoldNameProvider.notifier,
              parent: tag,
            ),
            title: tagName,
          ),
        ));
      } else {
        _removeTag(context, tagName, ref);
      }
    });
  }

  Widget _tagButton(BuildContext context, String tag, WidgetRef ref,
      {void Function(TapDownDetails)? onTapDown}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(100)),
      child: InkWell(
          // without this, the hover color does not respect the Container shape it's in
          // not sure if this is a bug or not
          borderRadius: BorderRadius.circular(100),
          hoverColor: Colors.blue.withOpacity(0.3),
          onTapDown: onTapDown ??
              (details) => _showTagMenu(context, tag, details.globalPosition, ref),
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(tag,
                  style: const TextStyle(
                    fontSize: 16,
                  )))),
    );
  }

  @override
  Widget createTile(
      {required BuildContext context,
      required WidgetRef ref,
      required void Function() onTap}) {
    return Container(
        padding: const EdgeInsets.all(5),
        child: ListTile(
          leading: const Icon(Icons.file_copy),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Row(
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
              Expanded(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: () sync* {
                          // generates each tag with 5-pixel spaces in-between
                          for (int i = 0; i < tags.length * 2; i++) {
                            if (i % 2 == 0) {
                              yield _tagButton(context, tags.elementAt(i ~/ 2), ref);
                            } else {
                              yield const SizedBox(
                                width: 5,
                              );
                            }
                          }
                          // finally, gives a plus button to add more tags
                          yield _tagButton(context, "+", ref,
                              onTapDown: (details) => _addTag(context, ref));
                        }()
                            .toList(),
                      )))
            ],
          ),
          onTap: onTap,
          trailing: PopupMenuButton<void Function(BuildContext, WidgetRef ref)>(
            tooltip: "Actions",
            itemBuilder: (context) => [
              PopupMenuItem(
                value: renameFile,
                child: const Text("Rename"),
              ),
              PopupMenuItem(
                value: deleteFile,
                child:
                    const Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
            onSelected: (func) => func(context, ref),
          ),
        ));
  }
}
