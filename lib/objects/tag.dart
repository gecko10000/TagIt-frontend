import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/misc/extensions.dart';
import 'package:tagit_frontend/objects/common.dart';
import 'package:tagit_frontend/requests.dart';

import '../misc/colors.dart';
import '../widgets/browsers/tag_browser.dart';

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
  Tag(this.name,
      {this.parent,
      Iterable<String> children = const [],
      Iterable<String> files = const []}) {
    this.children.addAll(children);
    this.files.addAll(files);
  }

  String fullName() => parent == null ? name : "$parent/$name";

  // opens the dialog for renaming the tag
  void renameTag(BuildContext context, WidgetRef ref) {
    final tagName = fullName();
    TextEditingController controller = TextEditingController(text: tagName);
    //controller.selection = TextSelection(baseOffset: tagName.length, extentOffset: tagName.length);

    Future<void> renameCallback(String newName, WidgetRef ref) async {
      try {
        await sendTagRename(this, newName);
      } on RequestException catch (ex, st) {
        context.showSnackBar(ex.message);
      }
      ref
          .read(tagBrowserListProvider(parent: parent).notifier)
          .refresh(parent: parent);
    }

    renameObject(context, "tag", fullName(), renameCallback, controller, ref);
  }

  // opens the file browser to select a place to move it to?
  void moveTag(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }

  // opens the confirmation for deletion
  void deleteTag(BuildContext context, WidgetRef ref) {
    Future<void> deleteCallback(WidgetRef ref) async {
      try {
        await sendTagDeletion(this);
      } on RequestException catch (ex, st) {
        context.showSnackBar(ex.message);
      }
      ref
          .read(tagBrowserListProvider(parent: parent).notifier)
          .refresh(parent: parent);
    }

    deleteObject(context, "tag", fullName(), deleteCallback, ref);
  }

  Widget _numIcon(IconData icon, int amount, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Icon(icon, color: color, size: 16),
              Text(" $amount", style: TextStyle(fontSize: 20, color: color)),
            ],
          )),
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
          leading: const Icon(Icons.tag, color: CustomColor.tag),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Row(children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _numIcon(Icons.tag, children.length, CustomColor.tag),
            _numIcon(Icons.file_copy, files.length, CustomColor.file),
          ]),
          trailing: PopupMenuButton<void Function(BuildContext, WidgetRef)>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: renameTag,
                child: const Text("Rename"),
              ),
              PopupMenuItem(
                value: moveTag,
                child: const Text("Move"),
              ),
              PopupMenuItem(
                value: deleteTag,
                child:
                    const Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
            onSelected: (func) => func(context, ref),
          ),
          //splashColor: Colors.green,
          //hoverColor: CustomColor.paynesGray,
          //tileColor: CustomColor.paynesGray.withOpacity(0.9),
          onTap: onTap,
        ));
  }
}
