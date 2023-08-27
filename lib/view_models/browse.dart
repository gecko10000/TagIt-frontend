import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/models/api/tags.dart';
import 'package:tagit_frontend/views/screens/back_scaffold.dart';
import 'package:tagit_frontend/views/widgets/browse.dart';

import '../models/objects/displayable.dart';
import '../models/objects/tag.dart';

part 'browse.g.dart';

@riverpod
Future<List<Displayable>> browseList(BrowseListRef ref, String? tag) =>
    TagAPI.getChildren(tag);

void openTag(BuildContext context, Tag tag) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          BackScaffold(child: BrowseScreen(tag: tag.fullName()))));
}
