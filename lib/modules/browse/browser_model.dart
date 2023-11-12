import 'package:flutter/material.dart';
import 'package:tagit_frontend/common/widget/riverpod_dialog.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/modules/browse/file_browser.dart';
import 'package:tagit_frontend/modules/browse/sorting_popup.dart';
import 'package:tagit_frontend/modules/content_view/content_view.dart';
import 'package:tagit_frontend/modules/management/tag/create_dialog.dart';
import 'package:tagit_frontend/modules/management/tag/delete_dialog.dart';
import 'package:tagit_frontend/modules/management/tag/rename_dialog.dart';
import 'package:uuid/uuid.dart';

import '../../model/object/tag.dart';
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
    BuildContext context, UuidValue? tagId, String? tagName,
    {bool stackPush = false}) {
  Navigator.of(context).pushReplacement(_route(tagId, tagName, stackPush));
}

void openContentView(BuildContext context, SavedFileState savedFile) {
  showRiverpodDialog(
      context: context, child: ContentViewer(fileId: savedFile.uuid));
}

void openCreateTagDialog(BuildContext context, TagState parentTag) {
  showRiverpodDialog(context: context, child: CreateDialog(parentTag));
}

void openDeleteTagDialog(BuildContext context, TagState tag) {
  showRiverpodDialog(context: context, child: DeleteTagDialog(tag));
}

void openSortingDialog(BuildContext context) {
  showRiverpodDialog(context: context, child: const SortingPopup());
}

void openAllFiles(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const FileBrowser()));
}

void openRenameTagDialog(BuildContext context, TagState tag) {
  showRiverpodDialog(context: context, child: TagRenameDialog(tag));
}
