

import 'package:flutter/material.dart';
import 'package:tagit_frontend/objects/tileable.dart';
import 'package:tagit_frontend/requests.dart';

import '../screens/browser.dart';

class Tag implements Tileable {
  final String name;
  final String? parent;
  final Set<String> children = {};
  final Set<String> files = {};

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
          json["name"],
          parent: json["parent"],
          children: (json["children"] as List).map((d) => d as String),
          files: (json["files"] as List).map((d) => d as String),
      );
  Tag(this.name, {this.parent, Iterable<String> children = const [], Iterable<String> files = const []}) {
    this.children.addAll(children);
    this.files.addAll(files);
  }

  String fullName() => parent == null ? name : "$parent/$name";

  // opens the dialog for renaming the tag
  void renameTag(BuildContext context, void Function()? refreshCallback) {
    TextEditingController controller = TextEditingController(text: fullName());
    Future<String?> newName = showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Renaming Tag \"${fullName()}\""),
          content: Stack(
            children: [
              TextField(
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
    newName.then((value) async {
      if (value == null) return;
      await sendTagRename(this, value);
      if (refreshCallback != null) refreshCallback();
    });
  }

  // opens the file browser to select a place to move it to?
  void moveTag(BuildContext context) {

  }

  // opens the confirmation for deletion
  void deleteTag(BuildContext context, void Function()? refreshCallback) {
    Future<bool?> deleted = showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Delete Tag"),
          content: Text("Are you sure you want to delete tag \"${fullName()}\"?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
                child: const Text("Delete", style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.pop(context, true),
                  /*Tag? parentTag = parent == null ? null : await getTag(parent!);
                  if (context.mounted) {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => BrowseScreen(parent: parentTag,))
                    );
                  }*/
            ),
          ],
        ),
    );
    deleted.then((value) async {
      if (!(value ?? false)) return;
      await sendTagDeletion(this);
      if (refreshCallback != null) refreshCallback();
    });

  }

  @override
  Widget createTile({required BuildContext context, void Function()? refreshCallback}) {
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
          trailing: PopupMenuButton<void Function(BuildContext, void Function()?)>(
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
            onSelected: (func) => func(context, refreshCallback),
          ),
          //splashColor: Colors.green,
          //hoverColor: CustomColor.paynesGray,
          //tileColor: CustomColor.paynesGray.withOpacity(0.9),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => BrowseScreen(parent: this)
              )
          ),
        )

    );
  }
}
