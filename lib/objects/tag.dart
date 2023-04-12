

import 'package:flutter/material.dart';
import 'package:tagit_frontend/objects/tileable.dart';

import '../requests.dart';
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
  void renameTag(BuildContext context) {

  }

  // opens the file browser to select a place to move it to?
  void moveTag(BuildContext context) {

  }

  // opens the confirmation for deletion
  void deleteTag(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => AlertDialog(
          content: Text("Are you sure you want to delete tag \"${fullName()}\"?"),
          actions: [
            TextButton(child: Text("No"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(child: Text("Yes"),
              onPressed: () => sendTagDeletion(this).then((value) async {
                  Navigator.pop(context);
                  Tag? parentTag = parent == null ? null : await getTag(parent!);
                  if (context.mounted) {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => BrowseScreen(parent: parentTag,))
                  );
                  }
                })),
          ],
        ),
    ));
  }

  @override
  Widget createTile(BuildContext context) {
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
          trailing: PopupMenuButton<void Function(BuildContext)>(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Rename"),
                value: renameTag,
              ),
              PopupMenuItem(
                child: Text("Move"),
                value: moveTag,
              ),
              PopupMenuItem(
                child: Text("Delete", style: TextStyle(color: Colors.red)),
                value: deleteTag,
              ),
            ],
            onSelected: (func) => func(context),
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
