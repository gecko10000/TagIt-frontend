

import 'package:flutter/material.dart';
import 'package:tagit_frontend/objects/tileable.dart';

import '../screens/browser.dart';

class Tag implements Tileable {
  final String name;
  final String? parent;
  final Set<String> children = {};
  final Set<String> files = {};

  factory Tag.fromJson(Map<String, dynamic> json) =>
      Tag(
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

  @override
  Widget createTile(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        child: ListTile(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Text(name,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
          trailing: Text("${children.length} | ${files.length}",
            style: const TextStyle(
              fontSize: 24,
            ),
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
