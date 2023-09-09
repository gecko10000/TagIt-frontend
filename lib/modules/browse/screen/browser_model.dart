import 'package:flutter/material.dart';
import 'package:tagit_frontend/common/widgets/back_scaffold.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/modules/browse/screen/browser.dart';
import 'package:tagit_frontend/modules/content_view/content_view.dart';

void openTagBrowser(BuildContext context, String tagName) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          BackScaffold(name: tagName, child: BrowseScreen(tagName: tagName))));
}

void openContentView(BuildContext context, SavedFileState savedFile) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ContentViewer(savedFile: savedFile));
}
