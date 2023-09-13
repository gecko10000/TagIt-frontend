import 'package:flutter/material.dart';
import 'package:tagit_frontend/common/widget/riverpod_dialog.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/modules/content_view/content_view.dart';

import 'screen.dart';

MaterialPageRoute _route(String tagName, bool stackPush) => MaterialPageRoute(
    builder: (context) => BrowseScreen(tagName: tagName, stackPush: stackPush));

void openTagBrowser(BuildContext context, String tagName,
    {bool stackPush = true}) {
  Navigator.of(context).push(_route(tagName, stackPush));
}

void popAndOpenTagBrowser(BuildContext context, String tagName) {
  Navigator.of(context).pushReplacement(_route(tagName, false));
}

void openContentView(BuildContext context, SavedFileState savedFile) {
  showRiverpodDialog(
      context: context, child: ContentViewer(savedFile: savedFile));
}
