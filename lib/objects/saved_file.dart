import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/objects/common.dart';

import '../requests.dart';
import '../widgets/browsers/file_browser.dart';

class SavedFile implements Tileable {
  final String name;
  final Set<String> tags = {};

  factory SavedFile.fromJson(Map<String, dynamic> json) {
    return
      SavedFile(
          json["name"],
          tags: (json["tags"] as List?)?.map((e) => e as String).toList() ?? []
      );
  }

  SavedFile(this.name, {List<String> tags = const []}) {
    this.tags.addAll(tags);
  }

  void renameFile(BuildContext context, WidgetRef ref) {
    TextEditingController controller = TextEditingController(text: name);
    // put cursor at the end of the filename but before the last period
    var startIndex = name.lastIndexOf(RegExp(r'\.'));
    startIndex = startIndex == -1 ? name.length : startIndex;
    controller.selection = TextSelection(baseOffset: startIndex, extentOffset: startIndex);

    Future<void> renameCallback(String newName, WidgetRef ref) async {
      await sendFileRename(this, newName);
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
      await sendFileDeletion(this);
      ref.read(fileBrowserListProvider.notifier).refresh();
    }
    deleteObject(context, "file", name, deleteCallback, ref);
  }

  @override
  Widget createTile({required BuildContext context, required WidgetRef ref, required void Function() onTap}) {
    return Container(
        padding: const EdgeInsets.all(5),
        child: ListTile(
          leading: const Icon(Icons.file_copy),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Text(name,
            style: const TextStyle(
              fontSize: 24,
            ),
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
                child: const Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
            onSelected: (func) => func(context, ref),
          ),
        )

    );
  }
}
