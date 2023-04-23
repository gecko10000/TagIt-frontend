import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/objects/common.dart';
import 'package:tagit_frontend/objects/tileable.dart';

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

  Future<void> _renameCallback(String newName, WidgetRef ref) async {
    await sendFileRename(this, newName);
    ref.read(fileBrowserListProvider.notifier).refresh();
  }

  void renameFile(BuildContext context, WidgetRef ref) {
    TextEditingController controller = TextEditingController(text: name);
    // select everything before the period
    var startIndex = name.lastIndexOf(RegExp(r'\.'));
    startIndex = startIndex == -1 ? name.length : startIndex;

    controller.selection = TextSelection(baseOffset: startIndex, extentOffset: startIndex);

    renameObject(context, "file", name, _renameCallback, controller, ref);
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
