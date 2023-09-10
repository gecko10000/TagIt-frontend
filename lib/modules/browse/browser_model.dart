import 'package:flutter/material.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/modules/content_view/content_view.dart';

import 'screen.dart';

void openTagBrowser(BuildContext context, String tagName) {
  Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => BrowseScreen(tagName: tagName)));
}

void openContentView(BuildContext context, SavedFileState savedFile) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ContentViewer(savedFile: savedFile));
}
