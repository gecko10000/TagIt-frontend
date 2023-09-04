import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/common/widgets/back_scaffold.dart';
import 'package:tagit_frontend/model/api/tags.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/modules/browser/browser.dart';
import 'package:tagit_frontend/modules/content_view/content_view.dart';

import '../../model/object/child_tag.dart';
import '../../model/object/tag.dart';

part 'browser_model.g.dart';

@riverpod
Future<Tag> browseList(BrowseListRef ref, String tagName) =>
    TagAPI.get(tagName);

void openTag(BuildContext context, ChildTag child) {
  final name = child.fullName();
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          BackScaffold(name: name, child: BrowseScreen(tagName: name))));
}

void openFile(BuildContext context, SavedFile savedFile) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ContentViewer(savedFile: savedFile));
}