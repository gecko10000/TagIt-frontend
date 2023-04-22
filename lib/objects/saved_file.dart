import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/objects/tileable.dart';
import 'package:tagit_frontend/screens/file_browser.dart';

import '../requests.dart';

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
    // select everything before the period
    var startIndex = name.lastIndexOf(RegExp(r'\.'));
    startIndex = startIndex == -1 ? name.length : startIndex;
    controller.selection = TextSelection(baseOffset: startIndex, extentOffset: 0);
    Future<String?> newNameFuture = showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Renaming File \"$name\""),
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
              onPressed: () => Navigator.pop(context, controller.value.text),
              child: const Text("Rename"),
            ),
          ],
        ));
    newNameFuture.then((newName) async {
      if (newName == null) return;
      await sendFileRename(this, newName);
      ref.read(fileBrowserListProvider.notifier).refresh();
    });
  }

  // TODO
  void manageFileTags(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }

  void deleteFile(BuildContext context, WidgetRef ref) {
    //deleteObject(context, "file", name, this, sendFileDeletion, refreshCallback);
  }

  @override
  Widget createTile({required BuildContext context, required WidgetRef ref}) {
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
          //splashColor: Colors.green,
          //hoverColor: CustomColor.paynesGray,
          //tileColor: CustomColor.paynesGray.withOpacity(0.9),
          onTap: () => {}, // without an onTap, hoverColor does not work
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
