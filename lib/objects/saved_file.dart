import 'package:flutter/material.dart';
import 'package:tagit_frontend/objects/common.dart';
import 'package:tagit_frontend/objects/tileable.dart';

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

  void renameFile(BuildContext context, void Function()? refreshCallback) {

  }

  void manageFileTags(BuildContext context, void Function()? refreshCallback) {

  }

  void deleteFile(BuildContext context, void Function()? refreshCallback) {
    deleteObject(context, "file", name, this, sendFileDeletion, refreshCallback);
  }

  @override
  Widget createTile({required BuildContext context, void Function()? refreshCallback}) {
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
          trailing: PopupMenuButton<void Function(BuildContext, void Function()?)>(
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
            onSelected: (func) => func(context, refreshCallback),
          ),
        )

    );
  }
}
