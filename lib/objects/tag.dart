import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/objects/common.dart';
import 'package:tagit_frontend/objects/tileable.dart';
import 'package:tagit_frontend/requests.dart';

import '../screens/browsers/tag_browser.dart';

class Tag implements Tileable {
  final String name;
  final String? parent;
  final Set<String> children = {};
  final Set<String> files = {};

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
          json["name"],
          parent: json["parent"],
          children: (json["children"] as List?)?.map((d) => d as String) ?? [],
          files: (json["files"] as List?)?.map((d) => d as String) ?? [],
      );
  Tag(this.name, {this.parent, Iterable<String> children = const [], Iterable<String> files = const []}) {
    this.children.addAll(children);
    this.files.addAll(files);
  }

  String fullName() => parent == null ? name : "$parent/$name";

  Future<void> _renameCallback(String newName, WidgetRef ref) async {
    await sendTagRename(this, newName);
    ref.read(tagBrowserListProvider(parent: parent).notifier).refresh(parent: parent);
  }

  // opens the dialog for renaming the tag
  void renameTag(BuildContext context, WidgetRef ref) {
    final tagName = fullName();
    TextEditingController controller = TextEditingController(text: tagName);
    //controller.selection = TextSelection(baseOffset: tagName.length, extentOffset: tagName.length);

    renameObject(context, "tag", fullName(), _renameCallback, controller, ref);
  }

  // opens the file browser to select a place to move it to?
  void moveTag(BuildContext context, WidgetRef ref) {

  }

  // opens the confirmation for deletion
  void deleteTag(BuildContext context, WidgetRef ref) {
    //deleteObject(context, "tag", fullName(), this, sendTagDeletion, refreshCallback);
  }

  @override
  Widget createTile({required BuildContext context, required WidgetRef ref}) {
    return Container(
        padding: const EdgeInsets.all(5),
        child: ListTile(
          leading: const Icon(Icons.tag),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Text(name,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
          trailing: PopupMenuButton<void Function(BuildContext, WidgetRef)>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: renameTag,
                child: const Text("Rename"),
              ),
              PopupMenuItem(
                value: renameTag,
                child: const Text("Move"),
              ),
              PopupMenuItem(
                value: deleteTag,
                child: const Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
            onSelected: (func) => func(context, ref),
          ),
          //splashColor: Colors.green,
          //hoverColor: CustomColor.paynesGray,
          //tileColor: CustomColor.paynesGray.withOpacity(0.9),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => TagBrowser(parent: this)
              )
          ),
        )

    );
  }
}
