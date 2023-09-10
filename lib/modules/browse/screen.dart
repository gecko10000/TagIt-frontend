import 'package:flutter/material.dart';
import 'package:tagit_frontend/modules/browse/browser.dart';

class BrowseScreen extends StatelessWidget {
  final String tagName;

  const BrowseScreen({required this.tagName, super.key});

  @override
  Widget build(BuildContext context) {
    final body = TagBrowser(tagName: tagName);
    if (tagName == "") {
      return body;
    }
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_upward),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(tagName)),
        body: body);
  }
}
