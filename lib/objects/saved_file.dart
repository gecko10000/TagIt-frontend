import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/misc/extensions.dart';
import 'package:tagit_frontend/objects/common.dart';

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

  // TODO
  void manageFileTags(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
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

  TextButton _tagButton(String tag, {void Function()? onPressed}) {
    return TextButton(
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(
                const Size(36, 36)), // maybe find a better way to do this
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100)))),
            backgroundColor: MaterialStateProperty.resolveWith((states) =>
                Colors.blue.withOpacity(
                    states.contains(MaterialState.hovered) ? 0.3 : 0.1))),
        onPressed: onPressed ?? () {},
        child: Text(
          tag,
          style: const TextStyle(
            fontSize: 16,
          ),
        ));
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
                              yield _tagButton(tags.elementAt(i ~/ 2));
                            } else {
                              yield const SizedBox(
                                width: 5,
                              );
                            }
                          }
                          // finally, gives a plus button to add more tags
                          yield _tagButton("+", onPressed: () {});
                        }()
                            .toList(),
                      )))
            ],
          ),
          onTap: onTap,
          trailing: PopupMenuButton<void Function(BuildContext, WidgetRef ref)>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: renameFile,
                child: const Text("Rename"),
              ),
              PopupMenuItem(
                value: manageFileTags,
                child: const Text("Manage Tags"),
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
