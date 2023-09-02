import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/model/api/tags.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/view/screen/browse.dart';
import 'package:tagit_frontend/view/screen/content_view.dart';
import 'package:tagit_frontend/view/widget/back_scaffold.dart';

import '../model/object/displayable.dart';
import '../model/object/tag.dart';

part 'browse.g.dart';

@riverpod
Future<List<Displayable>> browseList(BrowseListRef ref, String? tag) =>
    TagAPI.getChildren(tag);

void openTag(BuildContext context, Tag tag) {
  final String fullName = tag.fullName();
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          BackScaffold(name: fullName, child: BrowseScreen(tag: fullName))));
}

void openFile(BuildContext context, SavedFile savedFile) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ContentViewer(savedFile: savedFile));
}
