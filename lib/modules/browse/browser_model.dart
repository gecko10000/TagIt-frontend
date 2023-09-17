import 'package:flutter/material.dart';
import 'package:tagit_frontend/common/widget/riverpod_dialog.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/modules/content_view/content_view.dart';
import 'package:uuid/uuid.dart';

import 'screen.dart';

MaterialPageRoute _route(UuidValue? tagId, String? tagName, bool stackPush) =>
    MaterialPageRoute(
        builder: (context) =>
            BrowseScreen(tagId: tagId, tagName: tagName, stackPush: stackPush));

void openTagBrowser(BuildContext context, UuidValue tagId, String tagName,
    {bool stackPush = true}) {
  Navigator.of(context).push(_route(tagId, tagName, stackPush));
}

void popAndOpenTagBrowser(
    BuildContext context, UuidValue? tagId, String? tagName) {
  Navigator.of(context).pushReplacement(_route(tagId, tagName, false));
}

void openContentView(BuildContext context, SavedFileState savedFile) {
  showRiverpodDialog(
      context: context, child: ContentViewer(fileId: savedFile.uuid));
}
